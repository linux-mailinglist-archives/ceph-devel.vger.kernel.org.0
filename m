Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E355C2E3
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 14:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240353AbiF0MRc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jun 2022 08:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbiF0MRb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jun 2022 08:17:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7215DEF3
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 05:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58D7BB80F96
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 12:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7F5C3411D;
        Mon, 27 Jun 2022 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656332248;
        bh=LTxc+vgLEha0j1ugUB/7S2isq2yq4yrqnBigv7JiqFw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KfApHgZf5XC7UbKCTDIqwf7BWefrvD7YNMvra9gkd2CmRsJcVjMv5mtaqBF6yKKVr
         OlSeoGjjzygvB0xSLZ1wf4q6ZrBiUDHBymMJCKfgg9k87YTg0ZUd+TSIylu3ziuiS7
         Gy1pxqibZFQkPu1BcKsC4sxj0DmY5oJ7y/Lz5vtbOsPNYk/OREBdwlxYpbQYyowvFl
         UeOV3Bh6gZFQCCTI9dK0/Oh89wgaiggeatVQxclKGcr6uqEx5gYIVrBp9TXdWrWiyt
         Qi96KyfzvVpK+ZxlFzGyv5wlutRzohEMnzvL7MKrJsgIny76u7cTHtkZxBLzHm3rfQ
         33lIgeG+aOvKA==
Message-ID: <c1c25b6de0680bda2621e07e5a4de1bd3397fa6c.camel@kernel.org>
Subject: Re: [PATCH v2 0/2] ceph: switch to 4KB block size if quota size is
 not aligned to 4MB
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Mon, 27 Jun 2022 08:17:25 -0400
In-Reply-To: <20220627020203.173293-1-xiubli@redhat.com>
References: <20220627020203.173293-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-06-27 at 10:02 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> V2:
> - Switched to IS_ALIGNED() macro
> - Added CEPH_4K_BLOCK_SIZE macro
> - Rename CEPH_BLOCK to CEPH_BLOCK_SIZE
>=20
> Xiubo Li (3):
>   ceph: make f_bsize always equal to f_frsize
>   ceph: switch to use CEPH_4K_BLOCK_SHIFT macro
>   ceph: switch to 4KB block size if quota size is not aligned to 4MB
>=20
>  fs/ceph/quota.c | 32 ++++++++++++++++++++------------
>  fs/ceph/super.c | 28 ++++++++++++++--------------
>  fs/ceph/super.h |  5 +++--
>  3 files changed, 37 insertions(+), 28 deletions(-)
>=20

Reviewed-by: Jeff Layton <jlayton@kernel.org>
