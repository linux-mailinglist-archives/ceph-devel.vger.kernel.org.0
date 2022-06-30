Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D54560F42
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 04:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiF3CkA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 22:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiF3Cjx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 22:39:53 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402891EC7D
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 19:39:53 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id l6so15762774plg.11
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 19:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iQRs2041+dPtZaki1odhdgoUKK8BnC4iTyBJxMZhUNA=;
        b=C/faEpaRoP+xWp4v2g9T95d9EBtW77/H8nZ/A60r7o+yMQAJwp8u8Y1jSDlRiVXgcY
         8kMU2Oa/oazhx4j4nkHrLg5pVSkxlo4R6DUmdm6ro/M8H1aHdWH+rmJDYhSh3rKxPhAx
         JlxW0fuYPGlP4S9PgSQxfYoal0hqhEvYwD9M9RMrOXqmHNxQv5HJPgdpr/2HLezWUXtn
         X0SjcVb+gQ0E6IBJKf2JAG/QsHc8FwsiAByUCmtWVi+XOEQWAb5yXYUsSCibeCo90REu
         x5vy/gvxDMQWYEkJ9VOrIiIQ91ncppcTyRCFoUCPOVqJYlNMIifCENBLKuKP1dCVnaR7
         9Lig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQRs2041+dPtZaki1odhdgoUKK8BnC4iTyBJxMZhUNA=;
        b=RB9AZwNtiouBuVX2z7pPEfCBqKNt1f9IKSIjPPlYqGJD/tnHx/hqlTVWhXSTkZb8Lr
         NJE58YXlIX+/NTe1vrhstkPi+PosD2LztC2P0lcRBtQdgwt7gbyzxcQsWIfpuRSBQmp4
         6QTeckr8CayDKB3PoJSua8kg7an1pF8oO4WLP9JTDtPlMiuzNHM0FjixhgmU2UQGpa3J
         S5/uy85tdiTaZdh4yMmKu7EJ/50on/Ol80pSlVqxL+wWTcctEE93NAxYf/qn4R6U8yPZ
         CayiVqtI1R7OSZhmVD+DmkP0ePwSgrk85vhOlRpvzwUnZKecZsH4FV3d9BGmpe43UjnE
         2GiQ==
X-Gm-Message-State: AJIora8Dm1krWsQoXxLe4mHpEBBh0rQQM7Nxnf8vGAvlm2EUfrV+3C7j
        eAWRpU3V+6eJORJC3pt9/0MlLWpPQJvAdbjULg4=
X-Google-Smtp-Source: AGRyM1sYTnvDjYhUedDp6dcwlrBWSGOUhV3gKneEmwEwP6u6Ri8t7rxcCYDUKPZyUvuN8/iREfKgErSyunY3ML6+daE=
X-Received: by 2002:a17:90a:f314:b0:1ec:91a9:3256 with SMTP id
 ca20-20020a17090af31400b001ec91a93256mr7503189pjb.155.1656556792731; Wed, 29
 Jun 2022 19:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220627020203.173293-1-xiubli@redhat.com>
In-Reply-To: <20220627020203.173293-1-xiubli@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 30 Jun 2022 10:39:41 +0800
Message-ID: <CAAM7YA=CcNA8HigAG4wAedUN+1dDDB8G7qXiub=+5B7nN5bjFg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ceph: switch to 4KB block size if quota size is
 not aligned to 4MB
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Luis Henriques <lhenriques@suse.de>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

NACK,  this change will significantly increase mds load. Inaccuracy is
inherent in current quota design.

On Mon, Jun 27, 2022 at 10:06 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> V2:
> - Switched to IS_ALIGNED() macro
> - Added CEPH_4K_BLOCK_SIZE macro
> - Rename CEPH_BLOCK to CEPH_BLOCK_SIZE
>
> Xiubo Li (3):
>   ceph: make f_bsize always equal to f_frsize
>   ceph: switch to use CEPH_4K_BLOCK_SHIFT macro
>   ceph: switch to 4KB block size if quota size is not aligned to 4MB
>
>  fs/ceph/quota.c | 32 ++++++++++++++++++++------------
>  fs/ceph/super.c | 28 ++++++++++++++--------------
>  fs/ceph/super.h |  5 +++--
>  3 files changed, 37 insertions(+), 28 deletions(-)
>
> --
> 2.36.0.rc1
>
