Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795FB1DD324
	for <lists+ceph-devel@lfdr.de>; Thu, 21 May 2020 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgEUQh3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 May 2020 12:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgEUQh3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 May 2020 12:37:29 -0400
Received: from mxb1.seznam.cz (mxb1.seznam.cz [IPv6:2a02:598:a::78:89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54147C061A0E
        for <ceph-devel@vger.kernel.org>; Thu, 21 May 2020 09:37:29 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc2b.ko.seznam.cz (email-smtpc2b.ko.seznam.cz [10.53.13.45])
        id 17310aa1ca0ed32f17ab4cd1;
        Thu, 21 May 2020 18:37:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1590079046; bh=ChuV7Bk9SxxWDgohie/aLSyPd77de/23l9rwKHXM2hc=;
        h=Received:From:To:Subject:Date:Message-Id:References:Mime-Version:
         X-Mailer:Content-Type:Content-Transfer-Encoding;
        b=O1jbc/W2T98uSVthrxPbL7tdkc/z3KeOvCFeSytiqEGaIp5TeXoBuMmDfES5mmbAA
         sJpMUWSL6p4Qf7MIUmyFzkFqMPWzxiqiYUIULMFd56Ks3C8I9HDKgvbWiG+I5XzUMa
         WqGkKldSC8wu5GYZjdPZmd70SV1ehAGHk/zh+sdM=
Received: from unknown ([::ffff:88.146.49.155])
        by email.seznam.cz (szn-ebox-5.0.29) with HTTP;
        Thu, 21 May 2020 18:37:22 +0200 (CEST)
From:   <Michal.Plsek@seznam.cz>
To:     <ceph-devel@vger.kernel.org>, "Ilya Dryomov" <idryomov@gmail.com>
Subject: Re: ceph kernel client orientation
Date:   Thu, 21 May 2020 18:37:22 +0200 (CEST)
Message-Id: <23N.cjNb.4NGwgCQo9SQ.1Ungv2@seznam.cz>
References: <6n.cjI5.4P7G519BQ1k.1Um{AC@seznam.cz>
        <CAOi1vP9HvJd-Cdm4TnfEjNN-PooZCAPBwANpS88UfinkhJuUsg@mail.gmail.com>
        <da.cjLX.3v4GDfOKIZE.1UnDtd@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.0.57)
X-Mailer: szn-ebox-5.0.29
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

My mistake, I meant image id. Yesterday I decided to put en/decryption int=
o rbd_queue_rq() and process data while traversing buffer_head structures.=
 Do not worry, I am very much aware of Never Roll Out Your Own Crypto :), =
this is not my idea though. I am just working on someone else's idea.

Thanks for your help.

>

> Thanks for swift answer.

>

> (This is my usage in librbd.cc)

>

> Basically there is a folder with symmetric keys used for block encryptio=
n, one key for one disk in some pool. For identification of key I need (po=
ol_id, disk_id) of block. I am temporarily saving key to librbd::ImageCtx =
structure, so I don't have to get it from file every time. I use this key =
to encrypt/decrypt block data. Encrypt/decrypt is primitive, I'm not gonna=
 mention it here, but it is done over the data provided by functions rbd_r=
ead() and rbd_write().

>

> If you could point how to edit rbd.c content to achieve similar behaviou=
r, I would be much obliged.



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

