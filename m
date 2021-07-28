Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813093D8BB2
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Jul 2021 12:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhG1K2S (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Jul 2021 06:28:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48574 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbhG1K2R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Jul 2021 06:28:17 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BAFB72019B;
        Wed, 28 Jul 2021 10:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627468095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQJ2drdFS6OLTjD6a8P9pYU8AuQbQ1zNpiyTexvkd50=;
        b=RFXehj1KiJBTkwVG92cD8f6Fq9LMTa1n5J7hmb/V+bFHKyKXy9I2RuzGZ014/2fQZso8/O
        xlMk7qSBWQlOPnHDrHAmxxmzoDvMOXQE8Z6zF9PBzc5Ruf3F3BW5hCOSIiPmwfMkub+tGt
        V0HlW/NxDf4EyRH0x7Yych7jwmHcPtU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627468095;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQJ2drdFS6OLTjD6a8P9pYU8AuQbQ1zNpiyTexvkd50=;
        b=8rKblMX78/cihN1UGMdS5UF+fbn/FsNUStgEBDNVduU+/aeZGC52HM4axi6q8vGULhPBkx
        +V/L1uagoxWpjsDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 7042913D29;
        Wed, 28 Jul 2021 10:28:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id qW2IGD8xAWEMKQAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Wed, 28 Jul 2021 10:28:15 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 31abd3ed;
        Wed, 28 Jul 2021 10:28:14 +0000 (UTC)
Date:   Wed, 28 Jul 2021 11:28:14 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, pdonnell@redhat.com
Subject: Re: [PATCH v2] ceph: add a new vxattr to return auth mds for an inode
Message-ID: <YQExPj9b2I2ZMZW1@suse.de>
References: <20210727113509.7714-1-jlayton@kernel.org>
 <20210727184253.171816-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210727184253.171816-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 27, 2021 at 02:42:53PM -0400, Jeff Layton wrote:
> Add a new vxattr that shows what MDS is authoritative for an inode (if
> we happen to have auth caps). If we don't have an auth cap for the inode
> then just return -1.
> 
> URL: https://tracker.ceph.com/issues/1276
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> v2: ensure we hold the i_ceph_lock when working with the i_auth_cap.

Yeah, this lock is definitely needed here.  LGTM.

Cheers,
--
Luís


> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 1242db8d3444..159a1ffa4f4b 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -340,6 +340,18 @@ static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
>  			      ceph_cap_string(issued), issued);
>  }
>  
> +static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
> +				       char *val, size_t size)
> +{
> +	int ret;
> +
> +	spin_lock(&ci->i_ceph_lock);
> +	ret = ceph_fmt_xattr(val, size, "%d",
> +			     ci->i_auth_cap ? ci->i_auth_cap->session->s_mds : -1);
> +	spin_unlock(&ci->i_ceph_lock);
> +	return ret;
> +}
> +
>  #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
>  #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
>  	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> @@ -473,6 +485,13 @@ static struct ceph_vxattr ceph_common_vxattrs[] = {
>  		.exists_cb = NULL,
>  		.flags = VXATTR_FLAG_READONLY,
>  	},
> +	{
> +		.name = "ceph.auth_mds",
> +		.name_size = sizeof("ceph.auth_mds"),
> +		.getxattr_cb = ceph_vxattrcb_auth_mds,
> +		.exists_cb = NULL,
> +		.flags = VXATTR_FLAG_READONLY,
> +	},
>  	{ .name = NULL, 0 }	/* Required table terminator */
>  };
>  
> -- 
> 2.31.1
> 
