Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA52945EC0
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfFNNq3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 09:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfFNNq3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:46:29 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E2420866;
        Fri, 14 Jun 2019 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560519988;
        bh=ovlMXpgqsXCpaXo/AE1irJuB72ZjGB9Ts9Jdd8XX7QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex5+GmNDFdK9NX2Pn2xteg6AnMZoqwlgZyMfigth+PWyvvTj5q0bygpbhHXU8jhPz
         wEGOTw52RJi+ll4LMADHrHtSRoeiJhdjlHCfTRx32SvO3fZol38UaK8KPpGAFoP+Fv
         ISffvuSfNNYN2zYQFl6HHFyNobiS2K5GzT4/S8aQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     akpm@linux-foundation.org, idryomov@gmail.com, zyan@redhat.com,
        sage@redhat.com, agruenba@redhat.com
Subject: [PATCH 1/3] lib/vsprintf: add snprintf_noterm
Date:   Fri, 14 Jun 2019 09:46:23 -0400
Message-Id: <20190614134625.6870-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614134625.6870-1-jlayton@kernel.org>
References: <20190614134625.6870-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The getxattr interface returns a length after filling out the value
buffer, and the convention with xattrs is to not NULL terminate string
data.

CephFS implements some virtual xattrs by using snprintf to fill the
buffer, but that always NULL terminates the string. If userland sends
down a buffer that is just the right length to hold the text without
termination then we end up truncating the value.

Factor the formatting piece of vsnprintf into a separate helper
function, and have vsnprintf call that and then do the NULL termination
afterward. Then add a snprintf_noterm function that calls the new helper
to populate the string but skips the termination.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/kernel.h |   2 +
 lib/vsprintf.c         | 145 ++++++++++++++++++++++++++++-------------
 2 files changed, 103 insertions(+), 44 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2d14e21c16c0..2f305a347482 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -462,6 +462,8 @@ extern int num_to_str(char *buf, int size,
 extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
 extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
 extern __printf(3, 4)
+int snprintf_noterm(char *buf, size_t size, const char *fmt, ...);
+extern __printf(3, 4)
 int snprintf(char *buf, size_t size, const char *fmt, ...);
 extern __printf(3, 0)
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 791b6fa36905..ad5f4990eda3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2296,53 +2296,24 @@ set_precision(struct printf_spec *spec, int prec)
 }
 
 /**
- * vsnprintf - Format a string and place it in a buffer
+ * vsnprintf_noterm - Format a string and place it in a buffer without NULL
+ *		      terminating it
  * @buf: The buffer to place the result into
- * @size: The size of the buffer, including the trailing null space
+ * @end: The end of the buffer
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
- * This function generally follows C99 vsnprintf, but has some
- * extensions and a few limitations:
- *
- *  - ``%n`` is unsupported
- *  - ``%p*`` is handled by pointer()
- *
- * See pointer() or Documentation/core-api/printk-formats.rst for more
- * extensive description.
- *
- * **Please update the documentation in both places when making changes**
- *
- * The return value is the number of characters which would
- * be generated for the given input, excluding the trailing
- * '\0', as per ISO C99. If you want to have the exact
- * number of characters written into @buf as return value
- * (not including the trailing '\0'), use vscnprintf(). If the
- * return is greater than or equal to @size, the resulting
- * string is truncated.
- *
- * If you're not already dealing with a va_list consider using snprintf().
+ * See the documentation over vsnprintf. This function does NOT add any NULL
+ * termination to the buffer. The caller must do that if necessary.
  */
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+static int vsnprintf_noterm(char *buf, char *end, const char *fmt,
+			    va_list args)
 {
 	unsigned long long num;
-	char *str, *end;
+	char *str;
 	struct printf_spec spec = {0};
 
-	/* Reject out-of-range values early.  Large positive sizes are
-	   used for unknown buffer sizes. */
-	if (WARN_ON_ONCE(size > INT_MAX))
-		return 0;
-
 	str = buf;
-	end = buf + size;
-
-	/* Make sure end is always >= buf */
-	if (end < buf) {
-		end = ((void *)-1);
-		size = end - buf;
-	}
-
 	while (*fmt) {
 		const char *old_fmt = fmt;
 		int read = format_decode(fmt, &spec);
@@ -2462,18 +2433,69 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			str = number(str, end, num, spec);
 		}
 	}
-
 out:
+	/* the trailing null byte doesn't count towards the total */
+	return str-buf;
+}
+EXPORT_SYMBOL(vsnprintf_noterm);
+
+/**
+ * vsnprintf - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @args: Arguments for the format string
+ *
+ * This function generally follows C99 vsnprintf, but has some
+ * extensions and a few limitations:
+ *
+ *  - ``%n`` is unsupported
+ *  - ``%p*`` is handled by pointer()
+ *
+ * See pointer() or Documentation/core-api/printk-formats.rst for more
+ * extensive description.
+ *
+ * **Please update the documentation in both places when making changes**
+ *
+ * The return value is the number of characters which would
+ * be generated for the given input, excluding the trailing
+ * '\0', as per ISO C99. If you want to have the exact
+ * number of characters written into @buf as return value
+ * (not including the trailing '\0'), use vscnprintf(). If the
+ * return is greater than or equal to @size, the resulting
+ * string is truncated.
+ *
+ * If you're not already dealing with a va_list consider using snprintf().
+ */
+int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	int ret;
+	char *end;
+
+	/* Reject out-of-range values early.  Large positive sizes are
+	   used for unknown buffer sizes. */
+	if (WARN_ON_ONCE(size > INT_MAX))
+		return 0;
+
+	end = buf + size;
+
+	/* Make sure end is always >= buf */
+	if (end < buf) {
+		end = ((void *)-1);
+		size = end - buf;
+	}
+
+	ret = vsnprintf_noterm(buf, end, fmt, args);
+
+	/* NULL terminate the result */
 	if (size > 0) {
-		if (str < end)
-			*str = '\0';
+		if (ret < size)
+			buf[ret] = '\0';
 		else
-			end[-1] = '\0';
+			buf[size - 1] = '\0';
 	}
 
-	/* the trailing null byte doesn't count towards the total */
-	return str-buf;
-
+	return ret;
 }
 EXPORT_SYMBOL(vsnprintf);
 
@@ -2506,6 +2528,41 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 }
 EXPORT_SYMBOL(vscnprintf);
 
+/**
+ * snprintf_noterm - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @...: Arguments for the format string
+ *
+ * Same as snprintf, but don't NULL terminate the result.
+ */
+int snprintf_noterm(char *buf, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+	char *end;
+
+	/* Reject out-of-range values early.  Large positive sizes are
+	   used for unknown buffer sizes. */
+	if (WARN_ON_ONCE(size > INT_MAX))
+		return 0;
+
+	/* Make sure end is always >= buf */
+	end = buf + size;
+	if (end < buf) {
+		end = ((void *)-1);
+		size = end - buf;
+	}
+
+	va_start(args, fmt);
+	ret = vsnprintf_noterm(buf, end, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(snprintf_noterm);
+
 /**
  * snprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
-- 
2.21.0

