Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6425560F9F
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 05:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiF3Daz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 23:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiF3Daz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 23:30:55 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C003935DF0
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:30:53 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so1515870pjs.1
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1lF8MkXs5883DfUfDR1Xvu2FzEHm7pW23hqkIaejFGg=;
        b=ciGZORhFC6hDX6Cof/QgyGl5rYrdpGQpedbBrYaR2civl5FUazww7nwG97e8lyhrnm
         eea8qjk/U6WBeHse0nWPrjLFtDahL1JWvxq6YeyJc4U9aol5fEFr4SD5IPH2jMpdbGrR
         VsUGcL2A31eKZN6wvLL7sXhScZ7fAsU1toRQ28eclovbxT0hFjfS6Pay/MreHJMDER2A
         VDRE5kqZChcLXQCVjn6GwO/ga7ILzkQWJ8CvO2i1cLRaK2gkwWpN1abr7Kj3dXmb5G6Y
         RUkQAzBe7906rcdC4H27THc+9xalerWHZZeYQPPKk5yqGaZeWHFZKGphsXbrGWfeHscw
         JVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1lF8MkXs5883DfUfDR1Xvu2FzEHm7pW23hqkIaejFGg=;
        b=hAITmhKp4LPB1dcYnxYlwz9fUNTx7dv4xKuhByIP/LpbPFoqzQ+NIqDo3zNgSeJ89O
         PK1lyUeRS1nH+b5xs7LdludkxRmy2y9p3G3R1Q6jCUyqD51dDBugKHA+GmgFsJeOfhYP
         YyEaH6Km4LS8ZKI+u5MF0In4qW7TGX+tcYOCigIcrBJH6q4b3JdEtK0WIfZReslSCiza
         wgxTfMfD4n5qyLlRngplTxbrBdbezbIgAy+bPgpjmqjRQS2lNCn+GhuSrls1Vyp2qZUJ
         Er+Ds/lQUJ+n7Wu2JwHGXlC0iKO0eG2/nniDwKVYRwnryv+RfUJvoeLfVzpKcq7OJpEf
         TwyA==
X-Gm-Message-State: AJIora+SpX0qLIKgXOTmS0mfKVmc/uNThH5jAPpRWGNVqwY3ikzWUNXo
        eVe50ZfeRJo2ua8f4MXQwKStrwYntwHvnfzxXdM=
X-Google-Smtp-Source: AGRyM1seNPXqpfpDZm6hHzu7lrzg9GPoWVZvm3NBfXDyWT4pq9+Gnoym51q2cYl24AM4JmGsKRRyJYlqmgGSX0zv7Fs=
X-Received: by 2002:a17:902:ac90:b0:16a:1c0d:b586 with SMTP id
 h16-20020a170902ac9000b0016a1c0db586mr13565558plr.155.1656559853313; Wed, 29
 Jun 2022 20:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220627020203.173293-1-xiubli@redhat.com> <CAAM7YA=CcNA8HigAG4wAedUN+1dDDB8G7qXiub=+5B7nN5bjFg@mail.gmail.com>
 <04405a13-5d9e-232a-58fe-ef22783f4881@redhat.com>
In-Reply-To: <04405a13-5d9e-232a-58fe-ef22783f4881@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 30 Jun 2022 11:30:41 +0800
Message-ID: <CAAM7YAkBiMyYW8uZo8JB9Yn_8N4DH0H7Yr2013Yb4oQ7btss0w@mail.gmail.com>
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

On Thu, Jun 30, 2022 at 11:05 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/30/22 10:39 AM, Yan, Zheng wrote:
> > NACK,  this change will significantly increase mds load. Inaccuracy is
> > inherent in current quota design.
>
> Yeah, I was also thinking could we just allow the quota size to be
> aligned to 4KB if it < 4MB, or must be aligned to 4MB ?
>
> Any idea ?

make sense

>
> - Xiubo
>
>
> > On Mon, Jun 27, 2022 at 10:06 AM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> V2:
> >> - Switched to IS_ALIGNED() macro
> >> - Added CEPH_4K_BLOCK_SIZE macro
> >> - Rename CEPH_BLOCK to CEPH_BLOCK_SIZE
> >>
> >> Xiubo Li (3):
> >>    ceph: make f_bsize always equal to f_frsize
> >>    ceph: switch to use CEPH_4K_BLOCK_SHIFT macro
> >>    ceph: switch to 4KB block size if quota size is not aligned to 4MB
> >>
> >>   fs/ceph/quota.c | 32 ++++++++++++++++++++------------
> >>   fs/ceph/super.c | 28 ++++++++++++++--------------
> >>   fs/ceph/super.h |  5 +++--
> >>   3 files changed, 37 insertions(+), 28 deletions(-)
> >>
> >> --
> >> 2.36.0.rc1
> >>
>
