Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C574E4123
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Mar 2022 15:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbiCVO1h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Mar 2022 10:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbiCVOZH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Mar 2022 10:25:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107475EDD2
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 07:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFFADB81BC2
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 14:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC7DC340EC;
        Tue, 22 Mar 2022 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647958807;
        bh=X/+G4j46pLAnQ01dk3SFu8GKXZxWQW33G+uvadTVXF4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gGKmTO90dPOzGCUS9kafSJQ9bbWD/ZR2tvYsymoPLn2bldO41/79HMibHFY5Acq48
         /7Oz543SHG7X3UkHErbUEcsUNE65+1AKOADuvh0FBtREUOKm+JdreU4B+/54TzWbnq
         PkTcOUUorYEueqZrxdEXSsCzLDwoim58UD484wp3Svjne7c7ZxZcuN7AozmJPVGoSt
         bJQzIcTLl9NXbsDRByjw8XySiCnB3UcZkNNt/qR4YU9gxWDlc7XYkUgUyA5IuTrvw+
         PSG5a0J6Kj0k4ifEsMi7CvQO503vhOrDIybTqYO7cBlIsvU5s2g11w8v/dl1Dddwol
         O/GE5SQU9MnrA==
Message-ID: <1ab0277a318eb50827b9e9415b2f35d648967e79.camel@kernel.org>
Subject: Re: [PATCH v4 0/5] ceph/libceph: add support for sparse reads to
 msgr2 crc codepath
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Tue, 22 Mar 2022 10:20:06 -0400
In-Reply-To: <20220321182618.134202-1-jlayton@kernel.org>
References: <20220321182618.134202-1-jlayton@kernel.org>
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

On Mon, 2022-03-21 at 14:26 -0400, Jeff Layton wrote:
> This is a revised version of the sparse read code I posted a week or so
> ago. Sparse read support is required for fscrypt integration work, but
> may be useful on its own.
> 
> The main differences from the v3 set are a couple of small bugfixes, and
> the addition of a new "sparseread" mount option to force the cephfs
> client to use sparse reads. I also renamed the sparse_ext_len field to
> be sparse_ext_cnt (as suggested by Xiubo).
> 
> Ilya, at this point I'm mostly looking for feedback from you. Does this
> approach seem sound? If so, I'll plan to work on implementing the v2-secure
> and v1 codepaths next.
> 
> These patches are currently available in the 'ceph-sparse-read-v4' tag
> in my kernel tree here:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/
> 
> Jeff Layton (5):
>   libceph: add spinlock around osd->o_requests
>   libceph: define struct ceph_sparse_extent and add some helpers
>   libceph: add sparse read support to msgr2 crc state machine
>   libceph: add sparse read support to OSD client
>   ceph: add new mount option to enable sparse reads
> 
>  fs/ceph/addr.c                  |  18 ++-
>  fs/ceph/file.c                  |  51 ++++++-
>  fs/ceph/super.c                 |  16 +-
>  fs/ceph/super.h                 |   8 +
>  include/linux/ceph/messenger.h  |  29 ++++
>  include/linux/ceph/osd_client.h |  71 ++++++++-
>  net/ceph/messenger.c            |   1 +
>  net/ceph/messenger_v2.c         | 170 +++++++++++++++++++--
>  net/ceph/osd_client.c           | 255 +++++++++++++++++++++++++++++++-
>  9 files changed, 593 insertions(+), 26 deletions(-)
> 

I've pushed this series into a new branch in the ceph tree called
"wip-sparseread", if anyone wants to test it. Note that ms_mode=secure
and ms_mode=legacy settings do not work properly with sparse reads yet.

-- 
Jeff Layton <jlayton@kernel.org>
