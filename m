Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D36A4DB23A
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 15:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350420AbiCPONf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Mar 2022 10:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352804AbiCPONd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Mar 2022 10:13:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1491066FB7
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBD08B81B75
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 14:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BE5C340E9;
        Wed, 16 Mar 2022 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647439936;
        bh=+Nd4ENNH9RBOaFgICMFY3tf9UAphDrGSGIn1NP2Zs58=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oneWdMdJDvhiqFixOVsZy4olJ1N8GkgfYZ+d0j1bZqwpBpAvvnYXThWa9oEXti3H6
         rJvaUFKMpaWhuTIdNGDBso/CghlJBJf1x5u6L6HL+Ey/Wb3Is7Pfry02a39+v1k6ny
         jCoxyC6OfAYdef+oV1s7tIlIOLHuwhLFgszqFX4Rnu2G5P/4xjzQBaJv+aYaB3TJz+
         wqdFmCg9A/1WyRGcdljHyJp9cyQM+GRTLyVPE0fhq9ipK73Ke1xGGmx06RideSmqOb
         MOfJSpESUa+E17scLOZe3z+5IcYikBkVE1PoVBNClX+d8vX1Dd/D3LTDR6I+I73vTu
         EZif2m5I7vCwA==
Message-ID: <53f0a25ce305b60d02d0d9ac8ea0be192cdcfbc0.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: get snap_rwsem read lock in handle_cap_export
 for ceph_add_cap
From:   Jeff Layton <jlayton@kernel.org>
To:     Niels Dossche <dossche.niels@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 16 Mar 2022 10:12:14 -0400
In-Reply-To: <20220315152946.12912-1-dossche.niels@gmail.com>
References: <20220315152946.12912-1-dossche.niels@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-15 at 16:29 +0100, Niels Dossche wrote:
> ceph_add_cap says in its function documentation that the caller should
> hold the read lock on the session snap_rwsem. Furthermore, not only
> ceph_add_cap needs that lock, when it calls to ceph_lookup_snap_realm it
> eventually calls ceph_get_snap_realm which states via lockdep that
> snap_rwsem needs to be held. handle_cap_export calls ceph_add_cap
> without that mdsc->snap_rwsem held. Thus, since ceph_get_snap_realm
> and ceph_add_cap both need the lock, the common place to acquire that
> lock is inside handle_cap_export.
> 
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> ---
>  fs/ceph/caps.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index b472cd066d1c..a23cf2a528bc 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3856,6 +3856,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  	dout("handle_cap_export inode %p ci %p mds%d mseq %d target %d\n",
>  	     inode, ci, mds, mseq, target);
>  retry:
> +	down_read(&mdsc->snap_rwsem);
>  	spin_lock(&ci->i_ceph_lock);
>  	cap = __get_cap_for_mds(ci, mds);
>  	if (!cap || cap->cap_id != le64_to_cpu(ex->cap_id))
> @@ -3919,6 +3920,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  	}
>  
>  	spin_unlock(&ci->i_ceph_lock);
> +	up_read(&mdsc->snap_rwsem);
>  	mutex_unlock(&session->s_mutex);
>  
>  	/* open target session */
> @@ -3944,6 +3946,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  
>  out_unlock:
>  	spin_unlock(&ci->i_ceph_lock);
> +	up_read(&mdsc->snap_rwsem);
>  	mutex_unlock(&session->s_mutex);
>  	if (tsession) {
>  		mutex_unlock(&tsession->s_mutex);

Looks good. Merged into testing branch.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>
