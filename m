Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BD3913B9
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Aug 2019 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHQXuY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Sat, 17 Aug 2019 19:50:24 -0400
Received: from linux-libre.fsfla.org ([209.51.188.54]:51094 "EHLO
        linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbfHQXuY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 17 Aug 2019 19:50:24 -0400
X-Greylist: delayed 675 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Aug 2019 19:50:23 EDT
Received: from free.home (home.lxoliva.fsfla.org [172.31.160.164])
        by linux-libre.fsfla.org (8.15.2/8.15.2/Debian-3) with ESMTP id x7HNd3sx026395
        for <ceph-devel@vger.kernel.org>; Sat, 17 Aug 2019 23:39:05 GMT
Received: from livre (livre.home [172.31.160.2])
        by free.home (8.15.2/8.15.2) with ESMTPS id x7HNcfWR421836
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 17 Aug 2019 20:38:46 -0300
From:   Alexandre Oliva <oliva@gnu.org>
To:     ceph-devel@vger.kernel.org
Subject: fix for hidden corei7 requirement in binary packages
Organization: Free thinker, not speaking for the GNU Project
Date:   Sat, 17 Aug 2019 20:38:15 -0300
Message-ID: <ord0h3gy6w.fsf@lxoliva.fsfla.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

After upgrading some old Phenom servers from Fedora/Freed-ora 29 to
30's, to ceph-14.2.2, I was surprised by very early crashes of both
ceph-mon and ceph-osd.  After ruling out disk and memory corruption, I
investigated a bit noticed all of them crashed during pre-main() init
section processing, at an instruction not available on the Phenom X6
processors that support sse4a, but not e.g. sse4.1.

It turns out that much of librte is built with -march=corei7.  That's a
little excessive, considering that x86/rte_memcpy.h would be happy
enough with -msse4.1, but not with earlier sse versions that Fedora is
supposed to target.

I understand rte_memcpy.h is meant for better performance, inlining
fixed-size and known-alignment implementations of memcpy into users.
Alas, that requires setting a baseline target processor, and you'll only
get as efficient an implementation as what's built in.

I noticed an attempt for dynamic selection, but GCC rightfully won't
inline across different target flags, so we'd have to give up inlining
to get better dynamic behavior.  The good news is that glibc already
offers dynamic selection of memcpy implementations, so hopefully the
impact of this change won't be much worse than that of enabling dynamic
selection, without the complications.

If that's not good enough, compiling ceph with flags that enable SSE4.1,
AVX2 or AVX512, or with a -march flag that implicitly enables them,
would restore current performance, but without that, you will (with the
patch below) get a package that runs on a broader range of processors,
that the base distro (through the compiler's baseline flags) chooses to
support.  It's not nice when you install a package on a processor that's
supposed to be supported and suddenly you're no longer sure it is ;-)

Perhaps building a shared librte, so that one could build and install
builds targeting different ISA versions, without having to rebuild all
of ceph, would be a reasonable way to address the better tuning of these
performance-critical bits.



src/spdk/dpdk:

diff --git a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h b/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
index 7b758094d..ce714bf02 100644
--- a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
+++ b/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
@@ -40,6 +40,16 @@ extern "C" {
 static __rte_always_inline void *
 rte_memcpy(void *dst, const void *src, size_t n);
 
+#ifndef RTE_MACHINE_CPUFLAG_SSE4_1
+
+static __rte_always_inline void *
+rte_memcpy(void *dst, const void *src, size_t n)
+{
+  return memcpy(dst, src, n);
+}
+
+#else /* RTE_MACHINE_CPUFLAG_SSE4_1 */
+
 #ifdef RTE_MACHINE_CPUFLAG_AVX512F
 
 #define ALIGNMENT_MASK 0x3F
@@ -869,6 +879,8 @@ rte_memcpy(void *dst, const void *src, size_t n)
 		return rte_memcpy_generic(dst, src, n);
 }
 
+#endif /* RTE_MACHINE_CPUFLAG_SSE4_1 */
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/mk/machine/default/rte.vars.mk b/mk/machine/default/rte.vars.mk
index df08d3b03..6bf695849 100644
--- a/mk/machine/default/rte.vars.mk
+++ b/mk/machine/default/rte.vars.mk
@@ -27,4 +27,4 @@
 # CPU_LDFLAGS =
 # CPU_ASFLAGS =
 
-MACHINE_CFLAGS += -march=corei7
+# MACHINE_CFLAGS += -march=corei7


-- 
Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lxo
Be the change, be Free!                 FSF Latin America board member
GNU Toolchain Engineer                        Free Software Evangelist
Hay que enGNUrecerse, pero sin perder la terGNUra jamás - Che GNUevara
