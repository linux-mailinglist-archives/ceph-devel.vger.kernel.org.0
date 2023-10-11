Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0FB7C53FC
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Oct 2023 14:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346918AbjJKM2N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Oct 2023 08:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbjJKM2M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Oct 2023 08:28:12 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD28D9E
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 05:28:02 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c00df105f8so87078701fa.2
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 05:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1697027281; x=1697632081; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KhRvlvbfNNUdcA0ulFhXxzCGgb7/Qvy9mlYrvDGbA4o=;
        b=cN/B8LVK20ID3cbRoHCdy85aDxhYW2bmTgNYSKyMhID1L5XtN/oCGUaoeKe0Y8qR6V
         wWIcc9/V+S7SiC8cULvP2OrtOpaMyKK/xw44uWnuv/OkNfMDBwPReT3JjL3YgoFjQ2JG
         eMvcAX/djqNLa4MIq12a/tDfzZDrCO9MP10S907p8KYEdGanslH0PbbiUukqTbaTDgT7
         FpCz5dp/as2SM+evOuVmYCY4dAdRPCjrzoB8LMab9XyIXK+uF75rd5yfdaDlfU3NgzI3
         AijvrX3A4+QD/dwiAEzS9mMaz/jjwOUg82oUPDYbQT27fy5FIf7apoAf6Za5649y3D/c
         lsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697027281; x=1697632081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KhRvlvbfNNUdcA0ulFhXxzCGgb7/Qvy9mlYrvDGbA4o=;
        b=jceDqfaPUfT2dlZYhTZIy9fEsYje+folTySXtn21FEJOHeCaudqAVynEbzwTcmSpAr
         Z6aImCbnzEWauhdHkMIUDGavt4J3ib/wohivJOqL/VbzTcSefTdno0gzVWJB8anBZlRm
         96W2uvD1WVbsq3q23N3gR3GGAuJpd84tOS7bevA7p3qdlmg9N86omj9+xd/TgDfokEe5
         tpPFgxqahsDpOLJ8xDM+XK/BbB2IBkwMbblA0nXZ2G9y5P6f9fmN+fJgdiLks9Sc6rPx
         Uk0j4PRjgmYaJ9BpM7L9PzMy1nBw8N8D707DQfF2mWDmNxL4Icqke7cm3sAz50RfNfWq
         AYqQ==
X-Gm-Message-State: AOJu0YwYXPIcO3CzZ0XoyK5u9qQJAEXTczbrduX5xdbvIvu9+VsIbx6S
        zeleBSYSJWSSMvq7DPWEAOMvUWri7MUhrYDl/mhYOA==
X-Google-Smtp-Source: AGHT+IHm4h91Xo0Sfo6un9kAB1YWATtgKcIRKV/DG0s/oi+mth9sdLaot9TMvdLIG7eI6nTPi6+7LH1TSKKK+oU/b40=
X-Received: by 2002:a2e:998a:0:b0:2bc:b75e:b8b with SMTP id
 w10-20020a2e998a000000b002bcb75e0b8bmr18178845lji.38.1697027280733; Wed, 11
 Oct 2023 05:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <69dda7be-d7c8-401f-89f3-7a5ca5550e2f@oracle.com>
 <20231009144340.418904-1-max.kellermann@ionos.com> <20231010131125.3uyfkqbcetfcqsve@quack3>
 <CAKPOu+-nC2bQTZYL0XTzJL6Tx4Pi1gLfNWCjU2Qz1f_5CbJc1w@mail.gmail.com>
 <20231011100541.sfn3prgtmp7hk2oj@quack3> <CAKPOu+_xdFALt9sgdd5w66Ab6KTqiy8+Z0Yd3Ss4+92jh8nCwg@mail.gmail.com>
 <20231011120655.ndb7bfasptjym3wl@quack3> <CAKPOu+-hLrrpZShHh0o6uc_KMW91suEd0_V_uzp5vMf4NM-8yw@mail.gmail.com>
In-Reply-To: <CAKPOu+-hLrrpZShHh0o6uc_KMW91suEd0_V_uzp5vMf4NM-8yw@mail.gmail.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Wed, 11 Oct 2023 14:27:49 +0200
Message-ID: <CAKPOu+_0yjg=PrwAR8jKok8WskjdDEJOBtu3uKR_4Qtp8b7H1Q@mail.gmail.com>
Subject: Re: [PATCH v2] fs/{posix_acl,ext2,jfs,ceph}: apply umask if ACL
 support is disabled
To:     Jan Kara <jack@suse.cz>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.com>,
        Dave Kleikamp <shaggy@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        Christian Brauner <brauner@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 2:18=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
> But without the other filesystems. I'll resend it with just the
> posix_acl.h hunk.

Thinking again, I don't think this is the proper solution. This may
server as a workaround so those broken filesystems don't suffer from
this bug, but it's not proper.

posix_acl_create() is only supposed to appy the umask if the inode
supports ACLs; if not, the VFS is supposed to do it. But if the
filesystem pretends to have ACL support but the kernel does not, it's
really a filesystem bug. Hacking the umask code into
posix_acl_create() for that inconsistent case doesn't sound right.

A better workaround would be this patch:
https://patchwork.kernel.org/project/linux-nfs/patch/151603744662.29035.491=
0161264124875658.stgit@rabbit.intern.cm-ag/
I submitted it more than 5 years ago, it got one positive review, but
was never merged.

This patch enables the VFS's umask code even if the filesystem
prerents to support ACLs. This still doesn't fix the filesystem bug,
but makes VFS's behavior consistent.

Max
