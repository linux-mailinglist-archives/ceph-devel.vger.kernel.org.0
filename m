Return-Path: <ceph-devel+bounces-1148-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AAF88C946C
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 13:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C6A61C20A15
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 11:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6EC44C8C;
	Sun, 19 May 2024 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTf3aZaV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538591DA4C;
	Sun, 19 May 2024 11:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716118515; cv=none; b=G4EkGgL0qhpFrKf8EjwLC6eT62eepY+YidIrmN/aTOFznL72AgFkxzHxSYS7gNral59vuuoY46GKG1z/T5A/TJq80nyZ21l6fGStmrrria7qiBVbVsb2S9CayG6khcydO9c9l5vHxMteD3yCXTGNRr0gWSfQq6GhL1v8y01EI9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716118515; c=relaxed/simple;
	bh=isaENKlZ4Dah/OxcrVqJYrYbUtnL+lzE100loLpjCUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3AlJ9VGET1T/ldcS4sF7Z/TVWc6hK6XZ8bGf5FtUJ/0FoUovqCsSg1A2Q7SioOKNeeqMUmGps0s2qK7lV/OCLoAL5tHry4aHrnpyVaM+932Mkki9TWs+Dsvlp1tnGAnYY7tv4eTqREcswQ8C/JqORMWK/Fm2CrcZ/87FPVgacI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTf3aZaV; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716118514; x=1747654514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=isaENKlZ4Dah/OxcrVqJYrYbUtnL+lzE100loLpjCUQ=;
  b=DTf3aZaVQPMmuzn00F856J/rZBmXvEvRWBRTWgzMYebe4oyXKAT9XcL0
   hMfKUqCet2vNnrMZaxv1mkNTnWzoWoiI7IDdO+ViRSD+Q+DsvwF/i/kza
   fJ3vGH+uJ46BdkPg/v+Yb2AJpDE/XgsYKUkeL4BHL6CwJLPz0bcyTGcng
   /tJ4uanGZLAuriXtNybGqcfhb7BrLx4NOhXNkOLdXwr52aBl5E3gX4HrE
   /KxpHTC4mGTeDpdYLPeJat5B8f2+AHppLJKtdqW3zJhlJwmfWzdTu0Cr7
   6f1O+Vn5Blg9ctkDvSNsIqXGLTiZD3dmEQrWzFh+SDHSmJC/OYmU5vnot
   A==;
X-CSE-ConnectionGUID: SYixLLS6R621jPBg8n5KaA==
X-CSE-MsgGUID: RmLUmSTFSyyJvqxPeh7V0g==
X-IronPort-AV: E=McAfee;i="6600,9927,11076"; a="12471171"
X-IronPort-AV: E=Sophos;i="6.08,172,1712646000"; 
   d="scan'208";a="12471171"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2024 04:35:13 -0700
X-CSE-ConnectionGUID: e+Fvgo46RiiKvLpMd/vxEA==
X-CSE-MsgGUID: 8Vz8LuzuRQOvbwnqMjcXGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,172,1712646000"; 
   d="scan'208";a="36829411"
Received: from unknown (HELO 108735ec233b) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 19 May 2024 04:35:09 -0700
Received: from kbuild by 108735ec233b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s8eol-0003QC-0d;
	Sun, 19 May 2024 11:35:07 +0000
Date: Sun, 19 May 2024 19:34:53 +0800
From: kernel test robot <lkp@intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/2 net-next] libceph: Use sruct_size() in
 ceph_create_snap_context()
Message-ID: <202405191909.7qhhefnu-lkp@intel.com>
References: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>

Hi Christophe,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Christophe-JAILLET/libceph-Use-__counted_by-in-struct-ceph_snap_context/20240519-172142
base:   net-next/main
patch link:    https://lore.kernel.org/r/5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet%40wanadoo.fr
patch subject: [PATCH 1/2 net-next] libceph: Use sruct_size() in ceph_create_snap_context()
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20240519/202405191909.7qhhefnu-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240519/202405191909.7qhhefnu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405191909.7qhhefnu-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/ceph/snapshot.c: In function 'ceph_create_snap_context':
>> net/ceph/snapshot.c:32:25: error: implicit declaration of function 'sruct_size'; did you mean 'struct_size'? [-Werror=implicit-function-declaration]
      32 |         snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
         |                         ^~~~~~~~~~
         |                         struct_size
>> net/ceph/snapshot.c:32:43: error: 'snaps' undeclared (first use in this function); did you mean 'snapc'?
      32 |         snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
         |                                           ^~~~~
         |                                           snapc
   net/ceph/snapshot.c:32:43: note: each undeclared identifier is reported only once for each function it appears in
   cc1: some warnings being treated as errors


vim +32 net/ceph/snapshot.c

    11	
    12	/*
    13	 * Ceph snapshot contexts are reference counted objects, and the
    14	 * returned structure holds a single reference.  Acquire additional
    15	 * references with ceph_get_snap_context(), and release them with
    16	 * ceph_put_snap_context().  When the reference count reaches zero
    17	 * the entire structure is freed.
    18	 */
    19	
    20	/*
    21	 * Create a new ceph snapshot context large enough to hold the
    22	 * indicated number of snapshot ids (which can be 0).  Caller has
    23	 * to fill in snapc->seq and snapc->snaps[0..snap_count-1].
    24	 *
    25	 * Returns a null pointer if an error occurs.
    26	 */
    27	struct ceph_snap_context *ceph_create_snap_context(u32 snap_count,
    28							gfp_t gfp_flags)
    29	{
    30		struct ceph_snap_context *snapc;
    31	
  > 32		snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
    33		if (!snapc)
    34			return NULL;
    35	
    36		refcount_set(&snapc->nref, 1);
    37		snapc->num_snaps = snap_count;
    38	
    39		return snapc;
    40	}
    41	EXPORT_SYMBOL(ceph_create_snap_context);
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

