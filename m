Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3FA4C1331
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 13:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbiBWMuQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Feb 2022 07:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiBWMuQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Feb 2022 07:50:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95653A66F0
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 04:49:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A5FACE1AFB
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 12:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0E7C340E7;
        Wed, 23 Feb 2022 12:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620585;
        bh=pbhvy2ieOLyMFyhsEE63cCQn7SKoQ96WbE79NDW6USQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WdsupFX7DDWN+pSp90Xqyr/izCU0l6rFXq8temtvybdUyKgpmCjzuR5co1M2f718H
         lq53WAUaJ5DOzAQ7MyXS8GiS5kww9of0guxDg3StP9JPYZXxJBlj2TN/FCMpUu0s2k
         WtY9Za99YpTpYj2xmBlGk5VYg+uru4Bds+CtqgcXFgBvT7FPNKpBXh4I2mhURcjQo2
         2MIKo3zlMMiP3kXrnkp9wmU3WFyLXxg1RS5jR+PD1VQ2mj/uhNccODHqGCNLz/tEBr
         0Hys//pbAhZNEEK3qIOtOnHdRyYOqvn98roORD/6ahtatjcWjIi5Q1fNj1mJJrTgnk
         23ryYGatYpdEA==
Message-ID: <50aaea3ee9aa5ba2ba2d18c252856c8a6468cb66.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] ceph: fix cephfs rsync kworker high load issue
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 23 Feb 2022 07:49:43 -0500
In-Reply-To: <20220223015934.37379-1-xiubli@redhat.com>
References: <20220223015934.37379-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
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

On Wed, 2022-02-23 at 09:59 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> V3:
> - switch to use the kmem_cache_zalloc() to zero the memory.
> - rebase to the latest code in testing branch.
> 
> V2:
> - allocate the capsnap memory ourside of ceph_queue_cap_snap() from
> Jeff's advice.
> - fix the code style and logs to make the logs to be more readable
> 
> Xiubo Li (2):
>   ceph: allocate capsnap memory outside of ceph_queue_cap_snap()
>   ceph: misc fix for code style and logs
> 
>  fs/ceph/snap.c | 168 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 90 insertions(+), 78 deletions(-)
> 

LGTM!

Reviewed-by: Jeff Layton <jlayton@kernel.org>
