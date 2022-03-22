Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD834E3C5C
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Mar 2022 11:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiCVKXJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Mar 2022 06:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiCVKXB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Mar 2022 06:23:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833F97EB3F
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 03:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E95BB81B67
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 10:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5DAC340EC;
        Tue, 22 Mar 2022 10:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647944491;
        bh=+tGOm6ESLXYOd246G7ttfp/WsrjPY+BVTwrqfyHvFxg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=plSqojks9Ejz15B/4GASFqltIZLcs60JIWn/cLyBMeV4YtKZCYDXp2OfCuY3fY/16
         A7ZVG73y9kfGSWdrLYPMmLLiAy9gT/Kok9lxpME/Di7TeBl0+4AutGOebtzcnsohc2
         FPpsWtkcw/nkdRtCHhyNQ5g2js5KQmmV+IuHanhV8Dzg7IwnbCQ9yrxvuJ7YegjY1t
         zsxRL2JCnwQTlbKJIwlw+M8Am15R54iMmrpz0D2778K7UFDNlxQcibpeWYzobT/0UL
         HrucdIgDokA3zDnyzxf5A2iFYzkq6AjLtpeJR5MAeIBe/DsmC6qPbv5oNPn/nx3VQg
         YpsMyPs2eUvcQ==
Message-ID: <b1ad1c3ad02eed56af4d5bee6e81a43337ae928f.camel@kernel.org>
Subject: Re: [PATCH] ceph: remove incorrect session state check
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 22 Mar 2022 06:21:30 -0400
In-Reply-To: <20220322031502.496857-1-xiubli@redhat.com>
References: <20220322031502.496857-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-22 at 11:15 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Once the session is opened the s->s_ttl will be set, and when receiving
> a new mdsmap and the MDS map is changed, it will be possibly will close
> some sessions and open new ones. And then some sessions will be in
> CLOSING state evening without unmounting.
> 
> URL: https://tracker.ceph.com/issues/54979
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index cd0c780a6f84..4657412bfa53 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4779,8 +4779,6 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>  
>  bool check_session_state(struct ceph_mds_session *s)
>  {
> -	struct ceph_fs_client *fsc = s->s_mdsc->fsc;
> -
>  	switch (s->s_state) {
>  	case CEPH_MDS_SESSION_OPEN:
>  		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
> @@ -4789,10 +4787,6 @@ bool check_session_state(struct ceph_mds_session *s)
>  		}
>  		break;
>  	case CEPH_MDS_SESSION_CLOSING:
> -		/* Should never reach this when not force unmounting */
> -		WARN_ON_ONCE(s->s_ttl &&
> -			     READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN);
> -		fallthrough;
>  	case CEPH_MDS_SESSION_NEW:
>  	case CEPH_MDS_SESSION_RESTARTING:
>  	case CEPH_MDS_SESSION_CLOSED:

Reviewed-by: Jeff Layton <jlayton@kernel.org>
