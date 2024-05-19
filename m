Return-Path: <ceph-devel+bounces-1150-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D436F8C94AF
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 14:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62CDD1F21519
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 12:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD655481AB;
	Sun, 19 May 2024 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="BZzJlsLk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-27.smtpout.orange.fr [80.12.242.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7D0DF58;
	Sun, 19 May 2024 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716123319; cv=none; b=Wk6968E/67FeovUCmeOUBgqCYTUE7uI1w8ndiMoJJAyxCPhs8O3m0hvc2+GKFZDM5H/+6/BBD6xcjgAd3tsPA1h6UkpVFReUI8lzTDLM/iic9spWfZZch/7sQByGNCB9FgCPN98AN9XSTlHKplwdITWFqYKmEKxp1R04YwaDR3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716123319; c=relaxed/simple;
	bh=96ddWgy+DqQkkmfLAmqY9C/dPMMuWMqOSDKoVWxeAKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DeTQMdZiZIw5wOjloaXukgCuuPx9fMEz8cvfBFtIlTi4dx4E39jUiYmFC3K9PZnxyNyTgN93TQ2Qi0njXnVvLKSDUN76YPEqxIunV4BOb4qLEsZPtD72LdlOXgrDKbX4qqFiehPz0XMACn5dQBr0gQarijaJCRKDXVHcMgBkMeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=BZzJlsLk; arc=none smtp.client-ip=80.12.242.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id 8fvNsas0Vml3s8fvOsAwyi; Sun, 19 May 2024 14:46:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1716122764;
	bh=IdukyeSVMol9uozX3qDqOVLoOKjojIJiN8ffYrHylXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=BZzJlsLkWkm524qgL4YZGWx+ntPz7Rzw0DUp9YfZpHYTMG1V/qZ1j/xA0rqb31b6D
	 Ze1E4DqsikBm5Ill2qHE+XDEhXWC3ZFehpfiCphM3ASZMwpAAO/CIEfwIM+6x9P6Ky
	 x6WsGkQgBOq1nHhw0PEBknAxA1z+uduyhETuzPgM3mtjxFIH+esfSPTlHY8a47SGMQ
	 SbFz/W6Y7B139j0qJ0iTWL1RRCutlXtYtYAzuRhMi6FxijWkz0RdrpRJ5rWmCOJSgo
	 7QFtAkzsg4qdY6XoRzEF48NImLtbHFx5GWDL1P0HpI1Sm3lFTze6XFl5jLcuLSJln6
	 2MqonpmJnfoSw==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 19 May 2024 14:46:04 +0200
X-ME-IP: 86.243.17.157
Message-ID: <64403766-cc22-4dbe-b4b3-af3ad32fb9ea@wanadoo.fr>
Date: Sun, 19 May 2024 14:45:59 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2 net-next] libceph: Use sruct_size() in
 ceph_create_snap_context()
To: kernel test robot <lkp@intel.com>, Ilya Dryomov <idryomov@gmail.com>,
 Xiubo Li <xiubli@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>
 <202405191909.7qhhefnu-lkp@intel.com>
Content-Language: en-MW
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <202405191909.7qhhefnu-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 19/05/2024 à 13:34, kernel test robot a écrit :
> Hi Christophe,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on net-next/main]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Christophe-JAILLET/libceph-Use-__counted_by-in-struct-ceph_snap_context/20240519-172142
> base:   net-next/main
> patch link:    https://lore.kernel.org/r/5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet%40wanadoo.fr
> patch subject: [PATCH 1/2 net-next] libceph: Use sruct_size() in ceph_create_snap_context()
> config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20240519/202405191909.7qhhefnu-lkp@intel.com/config)
> compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240519/202405191909.7qhhefnu-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202405191909.7qhhefnu-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     net/ceph/snapshot.c: In function 'ceph_create_snap_context':
>>> net/ceph/snapshot.c:32:25: error: implicit declaration of function 'sruct_size'; did you mean 'struct_size'? [-Werror=implicit-function-declaration]
>        32 |         snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
>           |                         ^~~~~~~~~~
>           |                         struct_size
>>> net/ceph/snapshot.c:32:43: error: 'snaps' undeclared (first use in this function); did you mean 'snapc'?
>        32 |         snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
>           |                                           ^~~~~
>           |                                           snapc
>     net/ceph/snapshot.c:32:43: note: each undeclared identifier is reported only once for each function it appears in
>     cc1: some warnings being treated as errors
> 
> 
> vim +32 net/ceph/snapshot.c
> 
>      11	
>      12	/*
>      13	 * Ceph snapshot contexts are reference counted objects, and the
>      14	 * returned structure holds a single reference.  Acquire additional
>      15	 * references with ceph_get_snap_context(), and release them with
>      16	 * ceph_put_snap_context().  When the reference count reaches zero
>      17	 * the entire structure is freed.
>      18	 */
>      19	
>      20	/*
>      21	 * Create a new ceph snapshot context large enough to hold the
>      22	 * indicated number of snapshot ids (which can be 0).  Caller has
>      23	 * to fill in snapc->seq and snapc->snaps[0..snap_count-1].
>      24	 *
>      25	 * Returns a null pointer if an error occurs.
>      26	 */
>      27	struct ceph_snap_context *ceph_create_snap_context(u32 snap_count,
>      28							gfp_t gfp_flags)
>      29	{
>      30		struct ceph_snap_context *snapc;
>      31	
>    > 32		snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);

Ouch!

this was build-tested, but I must have made a mistake when editing the 
patch file to add the "net-next".

Sorry about that.
I'll resend when the net-next branch will re-open.

CJ

>      33		if (!snapc)
>      34			return NULL;
>      35	
>      36		refcount_set(&snapc->nref, 1);
>      37		snapc->num_snaps = snap_count;
>      38	
>      39		return snapc;
>      40	}
>      41	EXPORT_SYMBOL(ceph_create_snap_context);
>      42	
> 


