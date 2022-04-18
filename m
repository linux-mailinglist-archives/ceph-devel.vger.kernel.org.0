Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF2B504E91
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 11:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiDRJ5m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 05:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbiDRJ5h (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 05:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46A1112D
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 02:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92FB1B80E64
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 09:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FCCC385A8;
        Mon, 18 Apr 2022 09:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650275695;
        bh=Pgxeuofyj3QMrd+rpHJNp+j70qIfH0/T8G0qQ9UmVJk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fBhXoA5v8LJ8RLvoAPi6Klp65ivnBqJtnar134dDAcszSLusl9p1V3DSJhFPpRwiz
         W/yq/x58khEfZUXNVzKfZHzlvEXgzddClN2tK3ofgL67rVza4cMptYRbZ3PEnW4xAa
         YYg1V7ZTheVhvwAqSDzBf2e7zFKFY/A+zJIMpjtqSpCvG/qoTyaBcxDqYyLsOrsIM7
         IaK/8AXhTQaqaVu4GPVMNwwYgu05pAt86q7dtWMDrsIz5WuSJr3qW9fK0Fa0q4/3hl
         qpgUpRFcQkmXF8PsJ9cIiPDag90izcapzYR91DKmA4yWYfrsB0Xx3Vs7mdjl81tfaR
         /ph7gVo9guESQ==
Message-ID: <c819c3917b8807a2455733239055c91870be9142.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix possible NULL pointer dereference for
 req->r_session
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 18 Apr 2022 05:54:53 -0400
In-Reply-To: <20220418014440.573533-1-xiubli@redhat.com>
References: <20220418014440.573533-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-04-18 at 09:44 +0800, Xiubo Li wrote:
> The request will be inserted into the ci->i_unsafe_dirops before
> assigning the req->r_session, so it's possible that we will hit
> NULL pointer dereference bug here.
> 
> URL: https://tracker.ceph.com/issues/55327
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 69af17df59be..c70fd747c914 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2333,6 +2333,8 @@ static int unsafe_request_wait(struct inode *inode)
>  			list_for_each_entry(req, &ci->i_unsafe_dirops,
>  					    r_unsafe_dir_item) {
>  				s = req->r_session;
> +				if (!s)
> +					continue;
>  				if (unlikely(s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
>  					for (i = 0; i < max_sessions; i++) {
> @@ -2353,6 +2355,8 @@ static int unsafe_request_wait(struct inode *inode)
>  			list_for_each_entry(req, &ci->i_unsafe_iops,
>  					    r_unsafe_target_item) {
>  				s = req->r_session;
> +				if (!s)
> +					continue;
>  				if (unlikely(s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
>  					for (i = 0; i < max_sessions; i++) {

Reviewed-by: Jeff Layton <jlayton@kernel.org>
