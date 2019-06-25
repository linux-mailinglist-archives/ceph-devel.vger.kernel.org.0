Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D6F5523E
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbfFYOlZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52013 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbfFYOlZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so3131613wma.1
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jNIprajFpYogTMU1bZTaoNLOv+qvJodhIpTpehLnmfU=;
        b=fv02Mkql/WxDtFV1RJjb5GXXiAN0/mZTLse84dGrU1BHKRbcrhtlixHqgqy14E57Fb
         h9KZQc+FtA4PP4eMimE1oxpA+SeWLQZ+rsVsM8WUzV8gnF5+mVH92BTcLvcAd+XSLHpk
         eFoxmKcOumm+GHJ9o8iQ+NyRWMRye5j47x6u/kfOyaXxLE2kO65DR6cMTfB1vGH/n31r
         lwF6qxNrEImt2KPl7EQ4OQ9DSuob253KUDP/d4hOc8c0fPUPWl3cYg/pk7R2SoadB1zs
         Nxes0sNYrgWNFXRBpgiv2XJ6DpKywCbDNE0jH1MAGdYIt4Nu64IxlwQupBkTmd9OC7FF
         vkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jNIprajFpYogTMU1bZTaoNLOv+qvJodhIpTpehLnmfU=;
        b=bQUdl61q4We0q0RCT4ma6X8uCslJwk66TeyiPOPVW+htHGXXdEJ0xcqJK5al+Si97p
         x05Ut+EKJNan9O91a9/jtnve7zu3iKSZDuMEs8ByzUEFkw8SipZHY15m4FvoWWgkLsDe
         jFijDYwe9BnzTvRyXYLHJ40lvLOVc9j2KPYdxNvZvegDzd9rrIaabefLGdeHfwP0zwwe
         /Wi+61Iqf9SW0x/QFYQFbBHbPFj6BICLlajYDLE1fHrFRLbwiQBcKWWvFZySlw2f6MVl
         DrUotX+gv/msJoGdjdSy4mbsd0LIdaWg8cqrNfLUXbcc5BfzdcxFrTzZbaqAQXwjX5pk
         4liw==
X-Gm-Message-State: APjAAAWRD0MwXJOtEJgsJ1DhtaUiJMJU1e7bOlLKtV0zUt4NUejGpzKY
        8wF8sj2gFlk+CKye282WV34i+ybSs+o=
X-Google-Smtp-Source: APXvYqwEF9lQRVC4jeLlMfmsyZX+gefLxPyd2ezJNylaLsLa1xGdbn58XotSYiiV6OGzNnGgcxdYoQ==
X-Received: by 2002:a1c:96:: with SMTP id 144mr7452881wma.45.1561473682990;
        Tue, 25 Jun 2019 07:41:22 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:22 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 15/20] libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
Date:   Tue, 25 Jun 2019 16:41:06 +0200
Message-Id: <20190625144111.11270-16-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This time for rbd object map.  Object maps are limited in size to
256000000 objects, two bits per object.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/libceph.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 337d5049ff93..0ae60b55e55a 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -84,11 +84,13 @@ struct ceph_options {
 #define CEPH_MSG_MAX_MIDDLE_LEN	(16*1024*1024)
 
 /*
- * Handle the largest possible rbd object in one message.
+ * The largest possible rbd data object is 32M.
+ * The largest possible rbd object map object is 64M.
+ *
  * There is no limit on the size of cephfs objects, but it has to obey
  * rsize and wsize mount options anyway.
  */
-#define CEPH_MSG_MAX_DATA_LEN	(32*1024*1024)
+#define CEPH_MSG_MAX_DATA_LEN	(64*1024*1024)
 
 #define CEPH_AUTH_NAME_DEFAULT   "guest"
 
-- 
2.19.2

