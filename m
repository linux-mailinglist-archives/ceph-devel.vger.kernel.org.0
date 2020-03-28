Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793E41962EF
	for <lists+ceph-devel@lfdr.de>; Sat, 28 Mar 2020 02:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgC1Bqo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Mar 2020 21:46:44 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:35320 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgC1Bqo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 Mar 2020 21:46:44 -0400
Received: by mail-oi1-f174.google.com with SMTP id t25so10581117oij.2
        for <ceph-devel@vger.kernel.org>; Fri, 27 Mar 2020 18:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BixQoglgfcykdCNOmnPlwfTKhiRXOGp0DFvYlPOOD5g=;
        b=hMr8cj2VjdO4q8NfpJfn2W2mgLW5zEESqxaGK7Wjp/aXKRaG+wJyVR7giQtEDAyNHU
         +4d1vSxYK375v6/Jhf1PLCRCPNupZwVX3YOIjUa1eHdQZTgZ0UOjpXZ6No3NLYR9BGid
         1p2N647WemoIVLrWr+qDJZ8Z3hG/56dVNuQb8U2zQfrKpZng5sAmAzP+UCbQ4rLNlu0l
         SqT9t+oRnv53IhfoiXGHvgpHIs+V6HRY26g/RPpou90AxNG/Gyh2+qB3ZKwI0ddF6x68
         /W4RnMLJRC7hS9XqFhLKqmN/odvf9c9KiZqGZVnotq2cLGVZX49YLzZVw02pw9GKdXNr
         M0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BixQoglgfcykdCNOmnPlwfTKhiRXOGp0DFvYlPOOD5g=;
        b=TOVSPXo4A7mRi7LzF3srZEXANHeMrMFqH5jUNx+C6/Q41NrkE1F9iAcAAbjEli/ADt
         4Tk1WQ9yQVx0Q6e8AVXGeBISratnnCKOe8BkTpU6yvOr1YWecSwZ2LBL3qrw2e9HcKNA
         1X34i6hNGgOpLkZhlg0K9jKT7HeBu3FaPhpxDb6G+o6mF0m1fNJsRATiSSkqoyrByeE8
         pglu7rRGKhn/7h9lndpEUSpH6kOpOnHEimbTb0QE6EMWJ0S2stvccNX7Mv+BRk0MthEy
         Jp3SMbwRjkSGVvtITlYrt6mzuOtiJdhUGxp8i6hfyeW2LHz1I7QDagiOxr3mew22n5bd
         nC6A==
X-Gm-Message-State: ANhLgQ2lcfVhsSLEKVLEIbThDOZpk4FR4OftWEx53iLPIs2YY3Xahi2c
        zrPg+F9MoCa4JYllEWlxTrZ1fbSgTV+g/ZZr0xA=
X-Google-Smtp-Source: ADFU+vu3Gm78fdfPT/a0FTXC8WiaMGcQmrAyl/6z+3/BoX34QEFgA2a7uBpTSeCSTMIO8fdy+FtBY+wz3PzKJ7VZUoo=
X-Received: by 2002:aca:af12:: with SMTP id y18mr1195935oie.78.1585360001648;
 Fri, 27 Mar 2020 18:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAMWWNq-8H8JJsPdL1JC9pOKMQY9LawZDRxfKa7Ag8MWGJbBY5A@mail.gmail.com>
 <CAAM7YAnSxY8QkZWPLT=mDjjf4PVNd=vsi3zb3DEKKhEdivFXVA@mail.gmail.com>
In-Reply-To: <CAAM7YAnSxY8QkZWPLT=mDjjf4PVNd=vsi3zb3DEKKhEdivFXVA@mail.gmail.com>
From:   Xinying Song <songxinying.ftd@gmail.com>
Date:   Sat, 28 Mar 2020 09:46:30 +0800
Message-ID: <CAMWWNq-4eMR_AJHaNLEABRyYLZUzKajPKttvXoPpQ2mCB+b9rA@mail.gmail.com>
Subject: Re: mds: where is mdr->slave_commit called?
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for your reply, Yan!
Could you give more explanation about the mechanism for how an
ESlaveUpdate::OP_PREPARE log event is prevented from being trimmed
before slave mds receiving  MMDSSlaveRequest::OP_FINISH message from
master? It seems only when doing replay can an ESlaveUpdate log event
be added to LogSegment::slave_updates, which helps to prevent the log
event from being trimmed. Suppose a scenario that slave mds has
journaled log event, sent an OP_LINKPRPEACK to master, then trimmed
the log event, and crashed. The master also crashed before receiving
the ACK message. So there will no log events to be replayed for both
master and slave, but slave mds has modified the inode link count, and
no way to rollback.

I have been stuck in this question for a few days, can't figure it
out. Sincerely hoping you or anyone else can give some tips.

Thanks!

Yan, Zheng <ukernel@gmail.com> =E4=BA=8E2020=E5=B9=B43=E6=9C=8823=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8812:34=E5=86=99=E9=81=93=EF=BC=9A

>
> On Sun, Mar 22, 2020 at 3:40 PM Xinying Song <songxinying.ftd@gmail.com> =
wrote:
> >
> > Hi, everyone:
> > Could anybody give some tips about how `mdr->slave_commit` is called?
> >
> > As for `link_remote()`, steps are as follows:
> > 1. master mds sends OP_(UN)LINKPREP to salve mds.
> > 2. slave mds replys OP_LINKPREPACK to master mds after its journal has
> > been flushed.
> > 3. master mds continues to process the client request.
> >
> > I only find out there is a chance in MDCache::request_finish() that
> > `mdr->slave_commit` will be called. However, after a successful
> > journal flush, slave mds only sends an ACK to master mds and bypasses
> > MDCache::request_finish().
> > So when or where is `mdr->slave_commit` called?
> >
> > Thanks!
>
> master calls MDCache::request_finsih(),
> MDCache::request_drop_foreign_locks() sends
> MMDSSlaveRequest::OP_FINISH message to slaves.  slaves call
> MDCache::request_finsih() when receiving the message.
