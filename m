Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20055D563A
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2019 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfJMMpA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Oct 2019 08:45:00 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:41860 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbfJMMpA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Oct 2019 08:45:00 -0400
Received: by mail-io1-f53.google.com with SMTP id n26so31263340ioj.8
        for <ceph-devel@vger.kernel.org>; Sun, 13 Oct 2019 05:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qb3uBGDLBFB4nesy+F5UknOVQ2NWWEP6cjLrmd0aiXo=;
        b=g5nNHSQ7yJyGFKeDwjVnWiIzlrLq5d+IFokO9SWPucfLQmv5YnbR00PSqlRm3BAsdp
         JWN8se1RI6rorGdrEM3iwnBp1fs87CWB8/PcBJSb/b/m4k+fQbsaFK4CvowqyMRML9oJ
         35m6sQuOUxj4wiCZI4xk+xn81URMe5rX1aWNcu5eyCM0lIYIDALH3YumjlXCzVKTRe4y
         gnp22AvLoTAf1bs4MhOklPlbCpjpmq2VQEBZ/GBlUbzE92ZeETcN8BrzbbC7fwMVRKpm
         eaiGp2J0JZ4bRGOpTjR4plYd1DOZqWOW/FH0ha0HIj+dJ+IFL9qgHXgz/KMY2sbajsBz
         lYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qb3uBGDLBFB4nesy+F5UknOVQ2NWWEP6cjLrmd0aiXo=;
        b=PZDDi1Z5s7hgFlyxIvLYB2mqsNy4ggKctkO0hcZ+jiCFI3gA1N3vqBIIaMY+w/Dqlo
         uHghF4po6X/M8CbI3BO5BNT7IVlZ34/V5r4Jpzc3mpMG2wNykifDr9ReW0yzqh4bhlJY
         CPM7pEQHnXq8aK/tsY3JrC7zvwlIM3mKG47ZBDSVRHFM1tR3D6ToTbwTQmcU4j6XXUaF
         OSGDNpGIWoehBnPZF739T7QRXn4LilNbIwoI3J2/jTJfKBlYQj8q7OpFq7/qJnCurpQJ
         gTZxyv7iLIJZIAeH2FBrvPIjoAXRSlOgIbYZCY0D63Si7oYdU+Y8rixjL8YCqgg91SUV
         e31w==
X-Gm-Message-State: APjAAAXcDg/29JOvnSNwIgnfWvWsOmDF1i9QB6KFPLTkkKjfRrgr2niG
        Ol7HQ3gXm6/wCN0oYllqIVzI2FVVB1fx6GyDJjE=
X-Google-Smtp-Source: APXvYqwZqiD9JUFIpXxYMbqhPVkrivdwz3tC0SrCxofXYDQvSDhGawnv2qfgogZRVU29jBo6YZjUmF/nmNXugY18oqc=
X-Received: by 2002:a5d:9359:: with SMTP id i25mr28986169ioo.184.1570970699710;
 Sun, 13 Oct 2019 05:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <555f9bd9-8523-02ab-d7b0-97cd860c4d71@redhat.com>
In-Reply-To: <555f9bd9-8523-02ab-d7b0-97cd860c4d71@redhat.com>
From:   "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>
Date:   Sun, 13 Oct 2019 20:44:45 +0800
Message-ID: <CAMrPN_+U2d++xXGvY=SSBZZS_B447jzEEZZY9pPM6U1CfoDk5w@mail.gmail.com>
Subject: Re: local mode -- a new tier mode
To:     Mark Nelson <mnelson@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

After the sysbench prepare operation is completed, about 48883MB of db
data is generated.
I set the fast partition to 30GB, so in the sysbench run stage,
eviction was taking place.

Mark Nelson <mnelson@redhat.com> =E4=BA=8E2019=E5=B9=B410=E6=9C=8812=E6=97=
=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8812:15=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Honggang,
>
>
> I personally I find this very exciting!  I was hoping that we might
> eventually try local caching in bluestore especially given trends for
> larger NVMe devices and pmem.  When you were running performance tests,
> did you run any tests where the data set size was significantly larger
> than the available "fast" local tier cache (ie so that eviction was
> taking place)?  In the past, that's been the area we've really needed to
> focus on getting right.
>
>
> Mark
>
>
> On 10/11/19 11:04 AM, Honggang(Joseph) Yang wrote:
> > Hi,
> >
> > We implemented a new cache tier mode - local mode. In this mode, an
> > osd is configured to manage two data devices, one is fast device, one
> > is slow device. Hot objects are promoted from slow device to fast
> > device, and demoted from fast device to slow device when they become
> > cold.
> >
> > The introduction of tier local mode in detail is
> > https://tracker.ceph.com/issues/42286
> >
> > tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier-=
new
> >
> > This work is based on ceph v12.2.5. I'm glad to port it to master
> > branch if needed.
> >
> > Any advice and suggestions will be greatly appreciated.
> >
> > thx,
> >
> > Yang Honggang
