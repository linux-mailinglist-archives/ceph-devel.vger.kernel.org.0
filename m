Return-Path: <ceph-devel+bounces-3945-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B593C474FE
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 15:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CC626349C3B
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 14:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955C7312804;
	Mon, 10 Nov 2025 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gV570sKi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB4D1E2307;
	Mon, 10 Nov 2025 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762785991; cv=none; b=BCjxzW0850JD3PtxlF3vWgDYoia61j4m6BB/zsWSTlLoIkb88dflALF6i6Mfk3dwpsrQP/US0zADpqRczZBKWjS7k3xTIObxyfliZ4vWegKS+ni7fISlUs1Z6hMrNnlOx1f9aJv83SggOkBDEBLdgpfsSFwmLrdI/mhcHK5+A3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762785991; c=relaxed/simple;
	bh=hNYPNXkZfEkeQ3fadek900BypbpKuNUggnRflRe9x44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fAsEvhVttnDML83NCn7M3srFsRIoX0goxTUsHUhaBapa1pd8e/HSRtSEEClvYvxmoYYBhEOT8O5xYNdcS/HN5chzyuBWmk55kFC+1kg5SptDG9Zp8jsQQj95ITiYvFZ4DhobQJTkvosPRw6hJgan023rEEIJxLpOmMNlw0HMQLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gV570sKi; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762785989; x=1794321989;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hNYPNXkZfEkeQ3fadek900BypbpKuNUggnRflRe9x44=;
  b=gV570sKiVB8/x6kJopJV6G2pIKcA6WyzQyheyXIBKoARae2NIM+Wa6lr
   uLct3eK3sTqhbCHW+SMF45EKg/hT92FACHYsYtbMUAW42AJUzR5IixIW6
   na2moITy3brasUrWhd5yIEpNqVhp++AlcF8FGkM5W/NrXSw0hvrvVMCt0
   5jBFVHkeWC86pmbz5TXzQjl7UgxdlC2mkot+bibtER/QMBzP6KaheWecJ
   jqUlPsD4xmBRvXaymW6lDOZwjtIgS51GN445Mz9G+WhqpNpfn/+jpSMRm
   c1XD76tAhnjEpZyY5qQ85ws8NHkbOOWh5mMTRWGfNc6FutbzBOrtfF/Jp
   Q==;
X-CSE-ConnectionGUID: bjUzQIszRVOCT/0MedwJMA==
X-CSE-MsgGUID: ZGoQ8U6sRxC5zHfUc9mAHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="68682123"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="68682123"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 06:46:29 -0800
X-CSE-ConnectionGUID: g9jy/EdTRX6uBcXlthhDww==
X-CSE-MsgGUID: +pPfAfxOQ42eJoBumt+V4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="187997955"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa010.jf.intel.com with ESMTP; 10 Nov 2025 06:46:27 -0800
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 1EB6595; Mon, 10 Nov 2025 15:46:26 +0100 (CET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Cc: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build breakage
Date: Mon, 10 Nov 2025 15:44:04 +0100
Message-ID: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In a few cases the code compares 32-bit value to a SIZE_MAX derived
constant which is much higher than that value on 64-bit platforms,
Clang, in particular, is not happy about this

fs/ceph/snap.c:377:10: error: result of comparison of constant 2305843009213693948 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
  377 |         if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
      |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by casting to size_t. Note, that possible replacement of SIZE_MAX
by U32_MAX may lead to the behaviour changes on the corner cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/ceph/snap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c65f2b202b2b..521507ea8260 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -374,7 +374,7 @@ static int build_snap_context(struct ceph_mds_client *mdsc,
 
 	/* alloc new snap context */
 	err = -ENOMEM;
-	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
+	if ((size_t)num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
 		goto fail;
 	snapc = ceph_create_snap_context(num, GFP_NOFS);
 	if (!snapc)
-- 
2.50.1


