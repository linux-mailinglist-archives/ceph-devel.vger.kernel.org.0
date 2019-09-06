Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDDCAC219
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 23:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404455AbfIFVj3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Sep 2019 17:39:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37812 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404236AbfIFVj3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Sep 2019 17:39:29 -0400
Received: by mail-ed1-f67.google.com with SMTP id i1so7821245edv.4
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2019 14:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=croit.io; s=gsuite-croitio;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uScMYTvnMUuPa4nq3lUXiU4sUuKiwPJtwkCJGPc+ptw=;
        b=kwFMnM7SJzB7x5AJNHFan+dkPEkD2FX6FsyGPEof152TysekgemgAerkO2G5DpGxAf
         Y4wra/jDWx6XeZ6i+ZAdtBe9iY+Jrv7ndP2xtuNpoU8BWWuX3lusfI+XubWVZsmOXElb
         JdO6L5U/B4Er1V4CEAWf6vZPwXaxpT5ryoVGoMaWgeAax6N59M4vdZZGSx1Jb9IRLqFZ
         NtCuj8XIPl13/mVyhGPPy0nmnUAhmxIjWBXycaWdnIYC9Rc6w/evIOpHP9xj8e82q/3f
         YQ1Rvo61cqhmi1tyUzhfTw8NDritJAF4Xnx6veSl6xW3GkxtnRlcxUSTImTTcimIbcPC
         94Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uScMYTvnMUuPa4nq3lUXiU4sUuKiwPJtwkCJGPc+ptw=;
        b=I6ckgWNpfBbNVp+v7rRZcLa+5aKhe3VHCstRRkA9JRUqiO8ha5QkOzK7sWLYWasv/k
         CIbCgNRcy1Z7+LUfFsz57vrqfCuYEhBY4zAoHQGObZRk7H7w+5a02D42LuR61X0SMSs3
         uWaBl/4dDIWrh0Jj696YmUiJ25WVD42MjUE4h3RkWLTHUp7C01+ks5zGZ+2ka8Pgl0ZE
         IW01I5nvBSBggPhhItlZ8mP83+yLTrzTKCETXQGF4CPzoUUncTKP2Bnt6GKeLeKDJBQe
         7PyTNTNdCnhqE9WebzjG5jRsBCISqdesC8nMRxkemDh2cQUxpoEaDC9G1n+QPlQOOjrw
         bH5g==
X-Gm-Message-State: APjAAAWF3nJUdY3fY6ARHjr8Y2FJAZ3d+itISe6TVdQVG4CkPX4nk8DX
        7QFUu364Vdxli8S6V+uZh8lVVwVrmIzeYc39/7CJKQ==
X-Google-Smtp-Source: APXvYqwjnb8daLrt36MruBlC5imwatCjHV/52pGv/tcreyGw9plQ595dqOTzjNryacdTiL7sk4UrgXuWlgxhc/GXlBY=
X-Received: by 2002:a17:906:9716:: with SMTP id k22mr9311885ejx.284.1567805967204;
 Fri, 06 Sep 2019 14:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
 <CAC-Np1xhZoKqVVjMhCPnBoJ5Z0aPj6iL4UYJfgp7M+VXCs9vkA@mail.gmail.com>
 <CALi_L4-rkKonTLAcBK==qs4Cr190j00cbRCDOGWsBWy61RdwMQ@mail.gmail.com>
 <CAC-Np1zv8oHtGj_0L4gWa23KTf3tOnAs_JtTqhZYDvKzNinUpQ@mail.gmail.com>
 <CAC-Np1w45EGTW07ovfrK_sWNg5JNuMkwbs7kxcfBxr=98n6xsQ@mail.gmail.com>
 <7104c259-7874-3af7-f2b8-85b6066ec878@m-privacy.de> <CAC-Np1wdR+kFRnrNKhTyKphznGDu56i9P4mKfxEfNJYV9sWERg@mail.gmail.com>
In-Reply-To: <CAC-Np1wdR+kFRnrNKhTyKphznGDu56i9P4mKfxEfNJYV9sWERg@mail.gmail.com>
From:   Paul Emmerich <paul.emmerich@croit.io>
Date:   Fri, 6 Sep 2019 23:39:16 +0200
Message-ID: <CAD9yTbGxjM-DV0voOrtMtDE6kEL2dDQAMiUJvJD-3wZDVfBqNw@mail.gmail.com>
Subject: Re: ceph-volume lvm activate --all broken in 14.2.3
To:     Alfredo Deza <adeza@redhat.com>
Cc:     Amon Ott <a.ott@m-privacy.de>,
        Sasha Litvak <alexander.v.litvak@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

our debian repository now contains packages with the fix:
https://croit.io/2019/07/07/2019-07-07-debian-mirror


--=20
Paul Emmerich

Looking for help with your Ceph cluster? Contact us at https://croit.io

croit GmbH
Freseniusstr. 31h
81247 M=C3=BCnchen
www.croit.io
Tel: +49 89 1896585 90

On Fri, Sep 6, 2019 at 2:08 PM Alfredo Deza <adeza@redhat.com> wrote:
>
> Thank you all for confirming the fix, I'll follow up today with a
> proper pull request, but I can't tell when we can get a release once
> it lands in the various release branches.
>
> On Fri, Sep 6, 2019 at 4:23 AM Amon Ott <a.ott@m-privacy.de> wrote:
> >
> > Am 05.09.19 um 13:56 schrieb Alfredo Deza:
> > > While we try to fix this, in the meantime the only workaround is not
> > > to redirect stderr. This is far from ideal if you require redirection=
,
> > > but so far is the only workaround to avoid this problem.
> >
> > This bug also broke our ceph-deploy based installation scripts, even
> > with a single OSD. I can confirm that the fix you posted makes
> > ceph-deploy work for us again.
> >
> > Amon Ott
> > --
> > Dr. Amon Ott
> > m-privacy GmbH           Tel: +49 30 24342334
> > Werner-Vo=C3=9F-Damm 62       Fax: +49 30 99296856
> > 12101 Berlin             http://www.m-privacy.de
> >
> > Amtsgericht Charlottenburg, HRB 84946
> >
> > Gesch=C3=A4ftsf=C3=BChrer:
> >  Dipl.-Kfm. Holger Maczkowsky,
> >  Roman Maczkowsky
> >
> > GnuPG-Key-ID: 0x2DD3A649
> >
