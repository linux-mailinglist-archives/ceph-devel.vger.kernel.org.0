Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBC1DCDC9
	for <lists+ceph-devel@lfdr.de>; Thu, 21 May 2020 15:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgEUNPj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 May 2020 09:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbgEUNPi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 May 2020 09:15:38 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B61C061A0E
        for <ceph-devel@vger.kernel.org>; Thu, 21 May 2020 06:15:38 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id f3so7400281ioj.1
        for <ceph-devel@vger.kernel.org>; Thu, 21 May 2020 06:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FOV9sluA/ltu2/UuazV272NrLLALmpyoY+vLVtuD6w4=;
        b=vftBprYnKgikxgRIWa6y8Q2/fMbFDdtDiZKyMTyLv6HiK3YEeG53GEvNhiCzSAY6qd
         HdoU0mvUdSO2UbAfE0szucqz8Tjh6XwtELn1kyIk/Zv1JQnfidKTnAXgPI61fn3bDH6c
         wlljWzd88zH106qEqzkL2kv9P7o87yNOByHVZ8SawosH7g07jWK6bMt/BvwikX3d3h8b
         kRtF/AsSms0mQPkD89Ok3hZjrWLUFKFDToVLvHoeINoj/kdrwQQtAmjXVQjuDn06I+UL
         jPnf2RzcK6ROFdaWm/MrFDBP8/Zl7gvYhhzQSg6kdehauf96yY+G0odhpwUel8rF+o4i
         hW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FOV9sluA/ltu2/UuazV272NrLLALmpyoY+vLVtuD6w4=;
        b=oO+5OZwtji1tLMk6FvY8ArrYriNP55yRplAUrnmKfaZ8b3W/Z75PNbNiMjd6rhOUKQ
         1QJxh0EAFS2sChj+Whv1a81+MKkYjHMs9VII/vTfH8Bz5zRt8btRDLcL65qO1myg3i2X
         TgpT4pNoL15JCJZ6UZlxQJ9bsWzKGGHcCEn+kYeUUtcLpCKetFWey+YCRkcWbEyZAHzk
         wsABQBoY7bbVbdWV9Sqm9p80vk4aJ2z8h+uwjSEOl1a97srTEp+LxtTBwsqD74CLczHa
         E8hjw0RUNZMB3SSV9nrIJw61vbUVJHfhqSA0Gl+hBzAX253QA9BpRMQO8PnY7v2eGZ20
         P17A==
X-Gm-Message-State: AOAM532oVSJpXY0GmCCIWb++YCGiHj7kvBXTZgIxITrffyNP5E5Heagd
        Fmk/7zWM+qkE6Dinl3ECOZykZ+KP0gwVIoWeV4M=
X-Google-Smtp-Source: ABdhPJz7k7BQwwUnqA1IVxp83SkdiTmYU/iG0khdAEsJSafUalLrv7CNmzxOvV4m9oi+gK/UW7yFZbZnPRE4q0s6XPk=
X-Received: by 2002:a02:cf17:: with SMTP id q23mr3647153jar.39.1590066937787;
 Thu, 21 May 2020 06:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <6n.cjI5.4P7G519BQ1k.1Um{AC@seznam.cz> <CAOi1vP9HvJd-Cdm4TnfEjNN-PooZCAPBwANpS88UfinkhJuUsg@mail.gmail.com>
 <da.cjLX.3v4GDfOKIZE.1UnDtd@seznam.cz>
In-Reply-To: <da.cjLX.3v4GDfOKIZE.1UnDtd@seznam.cz>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 21 May 2020 15:15:43 +0200
Message-ID: <CAOi1vP8kz0PpBDwpp78pHP-gT5-FpcNcQ7L6omd_pj8fyOZLFw@mail.gmail.com>
Subject: Re: ceph kernel client orientation
To:     Michal.Plsek@seznam.cz
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 20, 2020 at 9:36 AM <Michal.Plsek@seznam.cz> wrote:
>
> Thanks for swift answer.
>
> (This is my usage in librbd.cc)
>
> Basically there is a folder with symmetric keys used for block encryption=
, one key for one disk in some pool. For identification of key I need (pool=
_id, disk_id) of block. I am temporarily saving key to librbd::ImageCtx str=
ucture, so I don't have to get it from file every time. I use this key to e=
ncrypt/decrypt block data. Encrypt/decrypt is primitive, I'm not gonna ment=
ion it here, but it is done over the data provided by functions rbd_read() =
and rbd_write().
>
> If you could point how to edit rbd.c content to achieve similar behaviour=
, I would be much obliged.

I'm not sure what exactly you mean by disk id, but I assume image
id (displayed by "rbd info" in block_name_prefix field) is probably
part of that.  It is looked up in rbd_dev_image_id(), called from
rbd_dev_image_probe().  More generally, do_rbd_add() is roughly
equivalent to rbd_open() in librbd.  Everything related to "opening"
the image is done in or under do_rbd_add().

struct rbd_device is passed pretty much everywhere, so if you are
storing a key in librbd::ImageCtx, struct rbd_device is probably
the place to put it.

As for encryption, the easiest would probably be to stick it into
__rbd_img_fill_request().  But I want to stress that bolting on
your own crypto is very error-prone and highly unlikely to produce
anything remotely secure.  Unless you are doing it to get familiar
with the codebase or just for fun, I would advise against it.

Thanks,

                Ilya
