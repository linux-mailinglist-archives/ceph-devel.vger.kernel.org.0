Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6CA67CCA4
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Jan 2023 14:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjAZNtf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Jan 2023 08:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjAZNtU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Jan 2023 08:49:20 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915804ABDE
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 05:48:43 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ss4so5109944ejb.11
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 05:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BSDv3VkMbcdrgwvF30JTDId1zjFJORHsWG05T/rU5go=;
        b=dE9OlVoq+Dahi9GgrPyD4bFuitYF3/0lVRAfnDmUzGsd9427Jf7r1KGHaD6oY8L5mz
         aorQ07Hi9l3eYEFYmPaZ8hdvVa2zcy7MUQ9AIqoDG1/ZnTkUBxfp3OnHhlsV5WpKEQjS
         MV2XG3cqVWa7v8T49Apuk5ijmwqOqFtm49ZG+6ynLmc6byJgYaFINWb5vZn+C7G+ZMQd
         DUkjBVt6qcorzN1UsL+htfqOk8rLEayTTS3/ttVI23iyfynF+gygPBGK1BymKkUgL0v8
         WUUYR6nJHxZKdNX3pkUxA7qTS1oXN+K168lW1OKTebI7scOykx6ICJnN/yIMoiq/WCaW
         Pohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BSDv3VkMbcdrgwvF30JTDId1zjFJORHsWG05T/rU5go=;
        b=zGUCQyP1ABiBh2jf9BiIcZTQzDCuyvtQIs3yeQOGmb3nzUTzAG2nu9uqqXefmElet7
         VgsOmC21WjdtJB2/ycurwWwnuwqOMHkvKHavAc3d5LiLAtivz49qvAZkhGGGcxgz0bz+
         SjcO5YSy8Lzdj6HoGdG7Kk8yIrW0+/YHp//3gqo7rtoZTj6Y4BqSNwI0HaC/gLF3762Z
         Dl9GtqFq5I+Ug3CyvQOQMYk89AbzpgzwLWJ6sHTtiOSoYHBztd2xE7GAmgSfhR9ptcaE
         CZ3ik8wYl+0ABMR7Liyo4yhiWqnySM4nVLy4Q2lxFiy+3anOtnh8EggIjrbZF+iv7GWa
         cVKg==
X-Gm-Message-State: AFqh2kpoFYv/j1yDAJh0mohkTBU+G0P+KMErdcak6+xg5nvbe4JXUejR
        fWPMAB2pwrSO3atTmgLRq0pwC0G8Jo+G8L4EsOM=
X-Google-Smtp-Source: AMrXdXskT17+oP8KqNF+YqtUpH3Uoe56+bn9mIBoLmuLafUNKxpN3zsiO2D+cnrNR0sghxvYWuPsMo6lNGVg76bvsoU=
X-Received: by 2002:a17:906:cd1a:b0:863:32c3:a28e with SMTP id
 oz26-20020a170906cd1a00b0086332c3a28emr4194124ejb.59.1674740919501; Thu, 26
 Jan 2023 05:48:39 -0800 (PST)
MIME-Version: 1.0
References: <Y9FffDxl2sa9762M@fedora>
In-Reply-To: <Y9FffDxl2sa9762M@fedora>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 26 Jan 2023 14:48:27 +0100
Message-ID: <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
Subject: Re: rbd kernel block driver memory usage
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, vromanso@redhat.com, kwolf@redhat.com,
        mimehta@redhat.com, acardace@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 25, 2023 at 5:57 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> Hi,
> What sort of memory usage is expected under heavy I/O to an rbd block
> device with O_DIRECT?
>
> For example:
> - Page cache: none (O_DIRECT)
> - Socket snd/rcv buffers: yes

Hi Stefan,

There is a socket open to each OSD (object storage daemon).  A Ceph
cluster may have tens, hundreds or even thousands of OSDs (although the
latter is rare -- usually folks end up with several smaller clusters
instead a single large cluster).  Under heavy random I/O and given
a big enough RBD image, it's reasonable to assume that most if not all
OSDs would be involved and therefore their sessions would be active.

A thing to note is that, by default, OSD sessions are shared between
RBD devices.  So as long as all RBD images that are mapped on a node
belong to the same cluster, the same set of sockets would be used.

Idle OSD sockets get closed after 60 seconds of inactivity.


> - Internal rbd buffers?
>
> I am trying to understand how similar Linux rbd block devices behave
> compared to local block device memory consumption (like NVMe PCI).

RBD doesn't do any internal buffering.  Data is read from/written to
the wire directly to/from BIO pages.  The only exception to that is the
"secure" mode -- built-in encryption for Ceph on-the-wire protocol.  In
that case the data is buffered, partly because RBD obviously can't mess
with plaintext data in the BIO and partly because the Linux kernel
crypto API isn't flexible enough.

There is some memory overhead associated with each I/O (OSD request
metadata encoding, mostly).  It's surely larger than in the NVMe PCI
case.  I don't have the exact number but it should be less than 4K per
I/O in almost all cases.  This memory is coming out of private SLAB
caches and could be reclaimable had we set SLAB_RECLAIM_ACCOUNT on
them.

Thanks,

                Ilya
