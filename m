Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080EC60C4F1
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Oct 2022 09:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiJYHXP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Oct 2022 03:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJYHXN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Oct 2022 03:23:13 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3268BEE08A
        for <ceph-devel@vger.kernel.org>; Tue, 25 Oct 2022 00:23:12 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id fy4so10287116ejc.5
        for <ceph-devel@vger.kernel.org>; Tue, 25 Oct 2022 00:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NoHeUYNvMZ8Jhd834+2xXSMoTbRof/mPGUP74Vej0KI=;
        b=LBgk0PCpfBPpok7ZvdWr7x0ny6qyw6TSmmvEKOZgWagzNVHNLzLpHn2YoTPb5tmQBo
         RY+v307Piul7gdrJh1x0Sm8dqWjpM9Nhx+/Hj0GRDumZmkeZow7UkWAH+Al8fIPki+Lr
         1bI2drwT6VgZsDYSpTsIjF/dZGzT55E1gySMHRHAWZm2j8ufDgp5PQEQZHjgL9x60SAF
         8rtKAACbYsDcsJXEcqC4s3xV+/mSXaNZnRSFBof7g9rua/7DNpZA87bwbtjVBbIbKUyo
         Nyz/nqZrLLNSkx/yvD2DtjB5xLk6Y/Csc8gnPg1LR1XHx3DOYYvzVnB9jxso8SqGnCtB
         JWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NoHeUYNvMZ8Jhd834+2xXSMoTbRof/mPGUP74Vej0KI=;
        b=v6CvOnpG0F8B7Dklz03RbTwu3TNSjDvs8gB37Bh3UUrzIGqs0g5VBPQj/2BsGtkYjc
         FEg76Tu1WBYbaKMKBLQzKl/xO3wpGBwZkCbGIB84M7ZD7uxl/IogYD2xlT78CROerj40
         6u5vJOzTe9TA52adZmRq5IHUTaV1pETERe9dSBJKTaVGgNWO7Jpg4QDsRm6KJZOF1CBc
         1uqu1ojpL5Eu13pyX5qpxzNQD65pnIswtlJdibtrmEBNTeoLCJ9/uh2HSprDJ87jphPE
         lHgfVLwjVo4SIW3+Mq0kMopfLY/2a24+xP9bOxhM8+MkyZWKPBIi6QoTMN1eLc9bicvO
         AOAw==
X-Gm-Message-State: ACrzQf1sMAaTg84+3NN065v5Zxg6ByUGf26tJt5FXY8lkH8a6Rzlzhn+
        +Ly/4F0qEkU9dEum0qfPhGvz6S/q3UffNO59xIrjnw==
X-Google-Smtp-Source: AMsMyM7G/z+f5imATz3TR9Yx3SkM9GucegkdYegyPVfFc3ynTl1gzqmPcdl068yMOOmYHFegHb0a61oFmgfZL5N6Xbs=
X-Received: by 2002:a17:906:1e08:b0:73d:c724:4876 with SMTP id
 g8-20020a1709061e0800b0073dc7244876mr30345435ejj.62.1666682590783; Tue, 25
 Oct 2022 00:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220927120857.639461-1-max.kellermann@ionos.com>
 <88f8941f-82bf-5152-b49a-56cb2e465abb@redhat.com> <CAKPOu+88FT1SeFDhvnD_NC7aEJBxd=-T99w67mA-s4SXQXjQNw@mail.gmail.com>
 <75e7f676-8c85-af0a-97b2-43664f60c811@redhat.com> <CAKPOu+-rKOVsZ1T=1X-T-Y5Fe1MW2Fs9ixQh8rgq3S9shi8Thw@mail.gmail.com>
 <baf42d14-9bc8-93e1-3d75-7248f93afbd2@redhat.com> <cd5ed50a3c760f746a43f8d68fdbc69b01b89b39.camel@kernel.org>
 <7e28f7d1-cfd5-642a-dd4e-ab521885187c@redhat.com> <8ef79208adc82b546cc4c2ba20b5c6ddbc3a2732.camel@kernel.org>
 <7d40fada-f5f8-4357-c559-18421266f5b4@redhat.com>
In-Reply-To: <7d40fada-f5f8-4357-c559-18421266f5b4@redhat.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Tue, 25 Oct 2022 09:22:59 +0200
Message-ID: <CAKPOu+_Jk0EHRDjqiNuFv8wL0kLXLLRZpx7AgWDPOWHzJn22xg@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/super: add mount options "snapdir{mode,uid,gid}"
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 25, 2022 at 3:36 AM Xiubo Li <xiubli@redhat.com> wrote:
> Currently cephx permission has already supported the 's' permission,
> which means you can do the snapshot create/remove. And for a privileged
> or specific mounts you can give them the 's' permission and then only
> they can do the snapshot create/remove. And all the others won't.

But that's a client permission, not a user permission.

I repeat: the problem is that snapshots should only be
accessible/discoverable/creatable by certain users (UIDs/GIDs) on the
client machine, independent of their permission on the parent
directory.

My patch decouples parent directory permissions from snapdir
permissions, and it's a simple and elegant solution to my problem.

> And then use the container or something else to make the specific users
> could access to them.

Sorry, I don't get it at all. What is "the container or something" and
how does it enable me to prevent specific users from accessing
snapdirs in their home directories?
