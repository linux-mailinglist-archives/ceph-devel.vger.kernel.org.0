Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56B505882
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 16:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244855AbiDROEt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 10:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245564AbiDRODe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 10:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D1F340D9
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 06:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8252460F63
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 13:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775DBC385A7;
        Mon, 18 Apr 2022 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650287345;
        bh=PWZYXBgLT28aiE177xrzG2PHK+KE3G2IcCUV/7XmzqM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TyhSy1eL3J6BU7bo8LIjpujuzUXneeB73aR0QuFCRUde0Wrkefzbk/ui+e6R2p4oL
         f/71wDsgXnqA3+sbaPst52U/9/fQslcdDMkgWM5plfRfFkw6nFbq/Cq9uSsFY/RjbA
         nBE46JnwuLyE0ccGKSBGVKyh60QLP5zgqUyZcBiJE091DHSzrw8mL2BBquiTk8cwE/
         AvvyWSBmrkxfH9d3LvCthEZVTo5yIfPm5itnMzwhXvngxP72gpC8VfLeGe506z2FZq
         WaD45oO8eVvz73B0OXt6g2bmpVeJ8x3mssIk8MQIi2oDZ34L45gc5EbFu/uy2Av3n/
         n8HfPgefoTu9g==
Message-ID: <42e3dfe97b0dd455ab7bd0e60afb2c0d2380ed8c.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] ceph: flush the mdlog for filesystem sync
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 18 Apr 2022 09:09:04 -0400
In-Reply-To: <20220418130218.738980-1-xiubli@redhat.com>
References: <20220418130218.738980-1-xiubli@redhat.com>
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

On Mon, 2022-04-18 at 21:02 +0800, Xiubo Li wrote:
> V2:
> - unsafe_request_wait() --> flush_mdlog_and_wait_inode_unsafe_requests()
> - wait_unsafe_requests() -> flush_mdlog_and_wait_inode_unsafe_requests()
> 
> 
> Xiubo Li (2):
>   ceph: rename unsafe_request_wait()
>   ceph: flush the mdlog for filesystem sync
> 
>  fs/ceph/caps.c       |  8 ++++----
>  fs/ceph/mds_client.c | 27 +++++++++++++++++++++------
>  2 files changed, 25 insertions(+), 10 deletions(-)
> 

Reviewed-by: Jeff Layton <jlayton@kernel.org>
