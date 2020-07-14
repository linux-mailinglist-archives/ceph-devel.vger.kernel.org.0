Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9F21FFD8
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jul 2020 23:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgGNVQZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jul 2020 17:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgGNVQZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Jul 2020 17:16:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F2C061755
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jul 2020 14:16:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c16so18863170ioi.9
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jul 2020 14:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SFWiBZHsid+MYc/j1B6r4IDq9E8ePYOkdYVwyryI9js=;
        b=pdRq434y5cmjVAJUNoUBlObZgdqoXdqvAsH/d2UaDEoNZAdnVFTDYTaoqjB4g0NFiW
         SJCiBrx7XlAn4alqto3224u3eSQx/oGeY6s0kLXoKPub5+2Oj+Qu1o4cedaIo6DYBDq7
         43wvKG+FPlLRfVMXcHnJFyzyQ1IULDshRoKdjodCdGO2EoeCM9+Fyh4x5kDuP98iDnR3
         bS1rL+EWB3F4bzENG0U5Sc287FPvuUa9Fssf9c687VjrRzHJzvhDm5TWq2MaNrT9SHqW
         4SToNxZzUIAWkCcxVLPSxsQGFRinoMoa7YEiNDXWqZqma1Zs3KycidV5F5bronT4tgKg
         HJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SFWiBZHsid+MYc/j1B6r4IDq9E8ePYOkdYVwyryI9js=;
        b=oSh+xbDki2/IyzdZvcuQD+dG5JAwHpOaoYAHysGB2gOsVn85zJKlttSx5Lcn544D0R
         WI7Lj6AQe0eO9hLVfouQU37vwgQNklQXczG6yDb/EMR/yNxrtAiCvwpPqbSuOS1M2fhF
         ghg1R426SJO5UPDu7LJGHyTgBJR9Tp338Toy1PKaP7aMPsStD1zMGzEyFp1kchUfaxI+
         BpI8MIo0r0I2oiybYguuJ3PC8EKKIUbkdfmTu1RyxPDyRI1Y0QMz8f83XrpGqNFR3PVz
         DE8yTJG4wJH8emewUxEsor7NlyNQ+tocWDhxvSMoPDorLhdltSmL2lg9Nd3BaX3TcPl2
         yKvA==
X-Gm-Message-State: AOAM532B4U4gx6GfA0EXcLagk0FH0YJkFzM4vFI2Fshd9f2XXauXR7uY
        ZrJXyfDnefgaSIhJF3vZlpgShKKgBS8eopkQdP0=
X-Google-Smtp-Source: ABdhPJwRF4sFKJkdOeql5j/PsdmncliSmNg7Dfovu2de0hi2ITpX//cGlmYOWridf5JPQHaDXVnmXa3rsteorvD2/NE=
X-Received: by 2002:a5d:9c0e:: with SMTP id 14mr6977680ioe.109.1594761384705;
 Tue, 14 Jul 2020 14:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+xD70OJhkhH=+5W7M8NM54VPh42FmbD3O0yqKe1p-+=yd9zXQ@mail.gmail.com>
In-Reply-To: <CA+xD70OJhkhH=+5W7M8NM54VPh42FmbD3O0yqKe1p-+=yd9zXQ@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 14 Jul 2020 23:16:28 +0200
Message-ID: <CAOi1vP-hmzEkkUWGOwxksQn8ny1HzgNURtnf1D33KQq4-49xgQ@mail.gmail.com>
Subject: Re: [Ceph-qa] multiple BLK-MQ queues for Ceph's RADOS Block Device
 (RBD) and CephFS
To:     Bobby <italienisch1987@gmail.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 13, 2020 at 8:40 PM Bobby <italienisch1987@gmail.com> wrote:
>
>
> Hi,
>
> I have a question regarding support for multiple BLK-MQ queues for Ceph's=
 RADOS Block Device (RBD). The below given link says that the driver has be=
en using the BLK-MQ interface for a while but not actually multiple queues =
until now with having a queue per-CPU. A change to not hold onto caps that =
aren't actually needed.  These improvements and more can be found as part o=
f the Ceph changes for Linux 5.7, which should be released as stable in ear=
ly June.
>
> https://www.phoronix.com/scan.php?page=3Dnews_item&px=3DLinux-5.7-Ceph-Pe=
rformance
>
> My question is: Is it possible that through Ceph FS (Filesystem in User S=
pace) I can develop a multi-queue driver for Ceph? Asking because this way =
I can avoid kernel space. (https://docs.ceph.com/docs/nautilus/start/quick-=
cephfs/)

[ trimming CCs to dev and ceph-devel ]

Hi Bobby,

I'm not sure what you mean by a "multi-queue driver for Ceph".
blk-mq is the block layer framework, it has nothing to do with
filesystems, whether local sitting on top of a block device (such
as ext4 or XFS) or distributed sitting on top of a network stack
(such as CephFS).

Do you have a specific project in mind or are you just looking to
make ceph-fuse faster?

Thanks,

                Ilya
