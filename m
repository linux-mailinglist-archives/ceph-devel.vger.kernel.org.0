Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2921DAC5E
	for <lists+ceph-devel@lfdr.de>; Wed, 20 May 2020 09:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgETHgQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 May 2020 03:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETHgQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 May 2020 03:36:16 -0400
Received: from mxb1.seznam.cz (mxb1.seznam.cz [IPv6:2a02:598:a::78:89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896F6C061A0E
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 00:36:15 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc2b.ko.seznam.cz (email-smtpc2b.ko.seznam.cz [10.53.13.45])
        id 65c2f4f4b8fd2d7a6558b284;
        Wed, 20 May 2020 09:36:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1589960173; bh=Os7/CFuh5Xv7LfIwhhGbI2QUWgONp4EITRVTwcmARis=;
        h=Received:From:To:Subject:Date:Message-Id:References:Mime-Version:
         X-Mailer:Content-Type:Content-Transfer-Encoding;
        b=mcsnNck7ALQB378YAs7l4W+QrkXEKSsNTEo+0Q4E/y/gvs5ndaSOcJXIM/fA6bahl
         im6Kzgxk+075tf3nzpIqP5WwhG9TybE0hElxYiYyhiA0xvPZ6J0L9Eon1DmeZv/kzW
         Q05BPCgU0IJwmXQWiwrU5FNMwI5DFIvG5MGNMIYE=
Received: from unknown ([::ffff:88.146.49.155])
        by email.seznam.cz (szn-ebox-5.0.29) with HTTP;
        Wed, 20 May 2020 09:36:07 +0200 (CEST)
From:   <Michal.Plsek@seznam.cz>
To:     <ceph-devel@vger.kernel.org>
Subject: Re: ceph kernel client orientation
Date:   Wed, 20 May 2020 09:36:07 +0200 (CEST)
Message-Id: <da.cjLX.3v4GDfOKIZE.1UnDtd@seznam.cz>
References: <6n.cjI5.4P7G519BQ1k.1Um{AC@seznam.cz>
        <CAOi1vP9HvJd-Cdm4TnfEjNN-PooZCAPBwANpS88UfinkhJuUsg@mail.gmail.com>
Mime-Version: 1.0 (szn-mime-2.0.57)
X-Mailer: szn-ebox-5.0.29
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for swift answer.

(This is my usage in librbd.cc)

Basically there is a folder with symmetric keys used for block encryption,=
 one key for one disk in some pool. For identification of key I need (pool=
_id, disk_id) of block. I am temporarily saving key to librbd::ImageCtx st=
ructure, so I don't have to get it from file every time. I use this key to=
 encrypt/decrypt block data. Encrypt/decrypt is primitive, I'm not gonna m=
ention it here, but it is done over the data provided by functions rbd_rea=
d() and rbd_write().

If you could point how to edit rbd.c content to achieve similar behaviour,=
 I would be much obliged.

M.



---------- P=C5=AFvodn=C3=AD e-mail ----------

Od: Ilya Dryomov <idryomov@gmail.com>

Komu: Michal.Plsek@seznam.cz

Datum: 19. 5. 2020 16:36:05

P=C5=99edm=C4=9Bt: Re: ceph kernel client orientation

On Tue, May 19, 2020 at 3:44 PM <Michal.Plsek@seznam.cz> wrote:

>

> Hello,

>

> I am trying to get to functions responsible for reading/writing to/openi=
ng RBD blocks in ceph client kernel module (alternatives to librbd=
=E2=80=99s rbd_read(), rbd_write() etc.). I presume it should be located s=
omewhere around drivers/block/, but until now I=E2=80=99ve been without lu=
ck. My idea is to edit these functions, rebuild the ceph kernel =E2=80=98r=
bd=E2=80=99 module and replace it. Since comments are pretty much missing =
everywhere, it would be nice to narrow my searching area.

>

> If you know anything about it, please let me know. Thanks, M.



Hi Michal,



Everything is in drivers/block/rbd.c.  The entry point is

rbd_queue_rq(), this is where all rbd requests are dispatched from.

After setting up where data is to be written from (for writes) or read

to (for reads), the details specific to each type of request (read,

write, discard or zeroout) are handled in __rbd_img_fill_request()

and then later on the respective state machine is kicked off.



The job of the state machine is to submit requests to the OSDs and

handle replies from the OSDs.  As in librbd, satisfying a single

user I/O request can require sending multiple OSDs requests, in some

cases sequentially.



Unfortunately, there is no one function to edit.  I might be able

to help more if you explain what you are trying to achieve.



Thanks,



                Ilya

