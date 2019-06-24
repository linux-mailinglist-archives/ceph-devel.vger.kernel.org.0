Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE3950942
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 12:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbfFXKxW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jun 2019 06:53:22 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:35914 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbfFXKxW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jun 2019 06:53:22 -0400
Received: by mail-qt1-f170.google.com with SMTP id p15so13937358qtl.3
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jun 2019 03:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tp+Ksm5TiAjZAl7hW3X06DGMt5g/4ipp7vqWbQUI8qo=;
        b=RW2XJQqRWngmHQBiBwTeZT4UViuhcCq0PgYGtPL6pHEHiLPApFDtzTi5mDjYV6AhkC
         BO1gWoW6wih7M2CxY3LFAk3ZcG+vkQwE4nMWCIcBX2AIuYOttX5GoGk/9ep+HokVs8XH
         fLHxKjW0X0D7eGYPTmdCy6EC3gl5ylQCPwVvduC4vi1YBrXIp8NLzejMqScYUJNZnTQd
         MqBoAo9V/830C/V2OSF8/n0V5TkGlccUSgVPcTO6jWybGJqQhIKlHLYy67RENrLi1TGX
         F2eAXwp7udGrLrv0T283Vz2Pzw/RNFBnOpe59DmbBDATU1szNhzUgxxUtvPyZ21os+ir
         eLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tp+Ksm5TiAjZAl7hW3X06DGMt5g/4ipp7vqWbQUI8qo=;
        b=lh/oYGTXeqjaN1DN4YSqNmRos2yK6JdH50TRLrI2UcIcUWwxTHaEPQXzRKFPNdlrHW
         xCb3HIbowYTXZaqKZUBDxZsxwiTZSKjRBBp63QTAXL83vfsRt2cysESFnDmhCXqtO9Xb
         iL2Yx1cqEwnP9cRv+07/xJXpf6t/nZAdV+vEtGWnKSqSQzBuIDO6w60SNpRf8tmnh6QI
         2o+mt65z1vwclPjgu0r70NXAJj0e4H1easJ9CXtRdQLBObfxZ5mYGmdeOfSolp77FB0X
         K+yRdPGINdTGhWe3kMXxv0+p1tBuyqqekZRg/Gfs8ADyszv9NvKQSdpre0geZycrwrYF
         P+jQ==
X-Gm-Message-State: APjAAAVYUZTT6bhh9Oc1u/AQJuomsA5pCsd4xeUiqMB7f+4Zko27Fx0Z
        pKU0TgaRIh8Uve8PtQvPNrDAWW7ATiI9r2Gxeb8=
X-Google-Smtp-Source: APXvYqwQysboJkqCIAC3E//UCzIuNtv1ZL1JxCsD/E6CDL4vvAINMCoo+N3nrm3SQaSangkwJ+GwGWVHnRlvBZD8ebs=
X-Received: by 2002:a0c:eecd:: with SMTP id h13mr56803064qvs.46.1561373600958;
 Mon, 24 Jun 2019 03:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <CABAwU-Zv1d1qT5n2-JEcm1vpK9XdTg30yzrhMoeQ2B4ujO=peA@mail.gmail.com>
 <CAJE9aONkU7L7wAZheQyZQ6kbaZ8C-jtCGB+qY6_rrmiuDijHzQ@mail.gmail.com>
In-Reply-To: <CAJE9aONkU7L7wAZheQyZQ6kbaZ8C-jtCGB+qY6_rrmiuDijHzQ@mail.gmail.com>
From:   huang jun <hjwsm1989@gmail.com>
Date:   Mon, 24 Jun 2019 18:53:09 +0800
Message-ID: <CABAwU-ZnTKthejKKkdQ8=pUfYmijHOTQC_mx4EH8zwCvecDTKQ@mail.gmail.com>
Subject: Re: ceph-monstore-tool rebuild question
To:     kefu chai <tchaikov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks, kefu.
I have another question, as we have limit the max ops in on
transaction during ceph-objectstore-tool update_osdmap()
to avoid the rebuild process consuming lots memory and killed by oom.
Should we add the same operation in ceph-monstore-tool::update_paxos()?

kefu chai <tchaikov@gmail.com> =E4=BA=8E2019=E5=B9=B46=E6=9C=8821=E6=97=A5=
=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=8810:30=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jun 13, 2019 at 10:06 AM huang jun <hjwsm1989@gmail.com> wrote:
> >
> > Hi,all
>
> Jun, sorry for the latency. got stuck by something else. =3D(
>
> > I recently read the ceph-monstore-tool code, and have a question about
> > rebuild operations.
> > In update_paxos() we read  osdmap, pgmap, auth and pgmap_pg records to
> > pending_proposal(a bufferlist) as the value of  the key paxos_1, and
> > set paxos_pending_v=3D1,
> > and set the paxos_last_committed=3D0 and paxos_first_committed=3D0;
> >
> > My question is if we start the mon after rebuild, let's say there is
> > only one mon now, the mon will not commit the paxos_pending_v=3D1, and
> > if we change the osdmap by 'ceph osd set noout' the new pending_v=3D1
> > will overwrite the former one in rebuild, so i think we don't need to
>
> agreed, unless the initial monmap requires more monitors. it will
> prevent the monitor from forming a quorum to write to the store. yeah,
> the paxos/1 will be overwritten by the first proposal at rebuilding
> the mondb. but i think we still need to store the "rebuild"
> transaction as a paxos proposal, as we need to apply the transaction
> on the sync client side, after the it syncs the chunks with the sync
> provider.
>
> probably we should just bump up the last_committed to a non-zero
> number, to preserve the rebuild transaction. actually, i was testing
> the fix of the issue you are talking about using the PR of
> https://github.com/ceph/ceph/pull/27465. but i didn't get a chance to
> look into the reason why it still failed..
>
> > set paxos_1=3Dpending_proposal, paxos_pending_v=3D1 in 'ceph-monstore-t=
ool
> > rebuild'.
> >
> > Thanks!
> > _______________________________________________
> > Dev mailing list -- dev@ceph.io
> > To unsubscribe send an email to dev-leave@ceph.io
>
>
>
> --
> Regards
> Kefu Chai
