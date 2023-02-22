Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE169F513
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Feb 2023 14:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjBVNEj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 08:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjBVNEh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 08:04:37 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DB9367CB
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 05:04:37 -0800 (PST)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CAD6E3F718
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 13:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677071075;
        bh=oc6NbxkoZ/NI1TnXzZmPTNRunV2eUQfN+lgY6nHapwg=;
        h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type;
        b=Yqt/Aoqhhd4letyIF2FG1jzmRjhe8xGM0tQGNI+dQbiYqY3xR9y+30lgXriMChNIT
         9WcUSnVUxR0VI3vigLYngST/na66oLK/rsqSFa9uOSIe7wa6aALfzpFmVg7SdbD3dG
         VMdVqjNwEeaEl856XdVjhdInGorWdGpZIva+XL+G3URZvoApptnXpLxWf2kuSx+e8P
         H0x1tisQQFo/5NvuUK7nSKxNDGbWef5Z80t2QxSCLFxs/8VXS+eLZKgRX2fneKOY9O
         SwIjfBD15c9OQ3Yb0pfJR3CELy8F3DWtE77vyw13YsXP5sBrTFhL2i+ya8ZHm6FRbg
         X6xCv3Ma9XIGg==
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-53700262a47so26706677b3.4
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 05:04:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oc6NbxkoZ/NI1TnXzZmPTNRunV2eUQfN+lgY6nHapwg=;
        b=5F+xi5TgHb5+O/x9gUiQnJmAKRCMONA1scUn9CPwOLFlnitAJEAkl/PQoGU6pPYHRJ
         hUCVg71krCMu8eKjaEbzQlrjT+hPBXdIfrY0/qJUFhXzETPrYwtqk1p/L38b5vYlF3KB
         7nCR2ZDwQT7CtJ60fkCV5e3kmtAXMp/z0BWetEczAHqS1i17FG47l6QiQcwd0Xm57D2p
         qqPtV/WhfxXGBEvH9hfC+EVZKuBiig1n7Fq2YvtIbJiQRZk1beE9KTEVMCdGCpfX2A5b
         SE05zZC0h19gPeNiS8KgyXE+3cqdqSgBbMfu2q6nmTBHfrm4j1jU64XrMEGYe+QG5/ET
         UzTA==
X-Gm-Message-State: AO0yUKW62ViZMlVX5PpDJuk5iE4c08wJzWz6Yju9Ayes8TG/VGqor0C7
        mpkbJ5om6B6tdmmcgWxQ1G/Q1Vtd6FFizHHsunIhqWuAnBFZ1aI6AWYF+y92Z10+4pRMWgACHCo
        IYWMTkaTYieyQ2p1AV3Toco9z2wasQVvGmRcb9i249gtI5G/QR7smmQGhVMzkHmg=
X-Received: by 2002:a81:ae43:0:b0:52e:b48f:7349 with SMTP id g3-20020a81ae43000000b0052eb48f7349mr779148ywk.6.1677071074668;
        Wed, 22 Feb 2023 05:04:34 -0800 (PST)
X-Google-Smtp-Source: AK7set9dOZlN/oMgB2aCFVepxcVD6BKBK8FxiGOFIZW3XheC2wuc14hu1mALMuCt41ykB5uHy0AzYAmB1MScKgohXkg=
X-Received: by 2002:a81:ae43:0:b0:52e:b48f:7349 with SMTP id
 g3-20020a81ae43000000b0052eb48f7349mr779144ywk.6.1677071074414; Wed, 22 Feb
 2023 05:04:34 -0800 (PST)
MIME-Version: 1.0
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 22 Feb 2023 14:04:23 +0100
Message-ID: <CAEivzxe7p6y8XN9ANs0Ff3wX4W3S=ZN-r05bF4p2nR7-M_wBPA@mail.gmail.com>
Subject: EBLOCKLISTED error after rbd map was interrupted by fatal signal
To:     ceph-devel@vger.kernel.org
Cc:     =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        idryomov@gmail.com, xiubli@redhat.com, jlayton@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi folks,

Recently we've met a problem [1] with the kernel ceph client/rbd.

Writing to /sys/bus/rbd/add_single_major in some cases can take a lot
of time, so on the userspace side
we had a timeout and sent a fatal signal to the rbd map process to
interrupt the process.
And this working perfectly well, but then it's impossible to perform
rbd map again cause we are always getting EBLOCKLISTED error.

We've done some brief analysis of the kernel side.

Kernelside call stack:
sysfs_write [/sys/bus/rbd/add_single_major
]
add_single_major_store
do_rbd_add
rbd_add_acquire_lock
rbd_acquire_lock
rbd_try_acquire_lock <- EBLOCKLISTED comes from there for 2nd and
further attempts

Most probably the place at which it was interrupted by a signal:
static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
{
...

        rbd_assert(!rbd_is_lock_owner(rbd_dev));
        queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
        ret = wait_for_completion_killable_timeout(&rbd_dev->acquire_wait,
        ceph_timeout_jiffies(rbd_dev->opts->lock_timeout)); <=== signal arrives

As far as I understand, we had been receiving the EBLOCKLISTED errno
because ceph_monc_blocklist_add()
sent the "osd blocklist add" command to the ceph monitor successfully.
We had removed the client from blocklist [2].
But we still weren't able to perform the rbd map. It looks like some
extra state is saved on the kernel client side and blocks us.

What do you think about it?

Links:
[1] https://github.com/lxc/lxd/pull/11213
[2] https://docs.ceph.com/en/quincy/cephfs/eviction/#advanced-un-blocklisting-a-client

Kind regards,
Alex
