Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405CA50295C
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Apr 2022 14:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353427AbiDOMIk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 Apr 2022 08:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353180AbiDOMH4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 15 Apr 2022 08:07:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD59AD111
        for <ceph-devel@vger.kernel.org>; Fri, 15 Apr 2022 05:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE66BB82C40
        for <ceph-devel@vger.kernel.org>; Fri, 15 Apr 2022 12:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FDDC385A5;
        Fri, 15 Apr 2022 12:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650024322;
        bh=ZKOzIHxqPkIKNDoUSWVCDN+e0b/TPs1MnZ2mplXDesI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eeY8ArECb5HVF3VtG7VRV8lHZUHy6MRtEs2yr8ADoc8K2ljmWnDqZqlVZgM1djBlr
         WZeZsJnM0eDaRLwv1q+1ByVYCKHrYnX8e3QT9EKvo0YhC11A4ul+KnJy3A89/TkyA1
         FJD4UTsZvjBWWi7ECDlASDD7RalFO4BKkrVsegIPhOEBdOujW5bKuMPOqY6eSJuenl
         Mv/gjD3nqZVhaklP4JM3fBk//r493/1xSb1rPJy7VDfFRqElcRvIg7AqYlPeTeCpwu
         pxi7lMWRe8giZR1hD7+dsXz/dmmopez+G8SGacgq91W5746JpEdu56G7GDAy3RjDeU
         eRIjzqz+NsMCw==
Message-ID: <1767a8c4889fb5f7d27c99928b47d7af73a9a64e.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix possible NULL pointer dereference for
 req->r_session
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 15 Apr 2022 08:05:20 -0400
In-Reply-To: <20220414054324.374694-1-xiubli@redhat.com>
References: <20220414054324.374694-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-04-14 at 13:43 +0800, Xiubo Li wrote:
> The request will be inserted into the ci->i_unsafe_dirops before
> assigning the req->r_session, so it's possible that we will hit
> NULL pointer dereference bug here.
> 
> URL: https://tracker.ceph.com/issues/55327
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 69af17df59be..6a9bf58478c8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2333,7 +2333,7 @@ static int unsafe_request_wait(struct inode *inode)
>  			list_for_each_entry(req, &ci->i_unsafe_dirops,
>  					    r_unsafe_dir_item) {
>  				s = req->r_session;
> -				if (unlikely(s->s_mds >= max_sessions)) {
> +				if (unlikely(s && s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
>  					for (i = 0; i < max_sessions; i++) {
>  						s = sessions[i];
> @@ -2343,7 +2343,7 @@ static int unsafe_request_wait(struct inode *inode)
>  					kfree(sessions);
>  					goto retry;
>  				}
> -				if (!sessions[s->s_mds]) {
> +				if (s && !sessions[s->s_mds]) {
>  					s = ceph_get_mds_session(s);
>  					sessions[s->s_mds] = s;
>  				}
> @@ -2353,7 +2353,7 @@ static int unsafe_request_wait(struct inode *inode)
>  			list_for_each_entry(req, &ci->i_unsafe_iops,
>  					    r_unsafe_target_item) {
>  				s = req->r_session;
> -				if (unlikely(s->s_mds >= max_sessions)) {
> +				if (unlikely(s && s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
>  					for (i = 0; i < max_sessions; i++) {
>  						s = sessions[i];
> @@ -2363,7 +2363,7 @@ static int unsafe_request_wait(struct inode *inode)
>  					kfree(sessions);
>  					goto retry;
>  				}
> -				if (!sessions[s->s_mds]) {
> +				if (s && !sessions[s->s_mds]) {
>  					s = ceph_get_mds_session(s);
>  					sessions[s->s_mds] = s;
>  				}

Good catch. I think it'd be cleaner to just do this in each loop though,
to keep the if conditions simpler:

    s = req->r_session;
    if (!s)
	    continue;

The bug and fix look real though.
-- 
Jeff Layton <jlayton@kernel.org>
