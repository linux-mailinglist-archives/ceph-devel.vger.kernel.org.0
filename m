Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8438A17DD3E
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 11:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgCIKRW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 06:17:22 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38351 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIKRW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 06:17:22 -0400
Received: by mail-io1-f65.google.com with SMTP id s24so8537866iog.5
        for <ceph-devel@vger.kernel.org>; Mon, 09 Mar 2020 03:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c1rVE+mWPYtAenBfSSkODGcC5oUe1N/p1Ag9T2ZurAQ=;
        b=aCbtTCZf3ojzMRuDQn6DeT/9dxOWvD25zbdXJrVE4D6/xPL3mDByVcVjqbzv2Bzjw9
         TNkTMx+tSrtsQtJjkFvNgEukO0FOwUS6/4fgESOE1yL6RrYJCP61kzmxQEGAmfZCSHlh
         cU+eYtxBMquKodCq5ZOuzX023CAE52YTABh5ajCRFVz9TH8lCPrpzdcVBhFtADi8lFCR
         wzTIhgZ0qkbCZt2Tn5O/SCkzRua7cCPFmRjK/Py8XN5XRHs7mI3eAC+3CEYCZ4nKCZ3G
         1jSCnpP9z494N2f5zM37nmQqMBlde6PCc7j6Ilb4Yiqt+Muq3HJocnMrTbvWCN8OJFZN
         V7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c1rVE+mWPYtAenBfSSkODGcC5oUe1N/p1Ag9T2ZurAQ=;
        b=HLRQEaO/ufJgmmQbR10zfjqVHWpPjGFgzeQMFusBB7mgiHIB95KgmMCZvr6mdoSp/H
         EcsikgnQk7EtkvMc7sGcuUflD4WbR2+qYpd+S3n0LkbcTjsZu6TOLR77nP9GR4OArynu
         zMnCKqHhFtSbT1DbEWvr9IVI1W4DgLCPHpv4cYG5Qp8SWrt5TiHGxyem2oEWlLY1BwK5
         Uq0td7zDoOlS9BtakuZhT+JHOVnooJkGI40G8quf00HmLtwdNqU7Zh9242XDSBbBVkKs
         IqB6BYltZ/FpkLIPS+MWLp4dPrvW8wzYlMgHqKPPfQJWpLlflMyetPH28NOvcE6YWJHi
         0d5Q==
X-Gm-Message-State: ANhLgQ1/Zfaqt99f2NV0SM8p/ugAOZF4m2OjZy4uqxHDlJ+hKYYSo/w0
        D+wY6bhVRPtsuIGV0YsHcCSIelzg41/gavPtfZ8=
X-Google-Smtp-Source: ADFU+vvkW0mmTRAY63bUI5W2pkLXOGZ8KXpJOo4+fkyws5WUJzLbFCViCW+iLGY/3QftmcGF3TTzBxZuVsOhcIA/dX8=
X-Received: by 2002:a5d:8555:: with SMTP id b21mr12571682ios.200.1583749041538;
 Mon, 09 Mar 2020 03:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <CANA9Uk54Ygo98sjozbU_HcAGjocSV2ui=-=imrDTCpdLOHhx6Q@mail.gmail.com>
 <CANA9Uk5eR41ZBYU_XGpgQoLwO8MnGTFuu6L+OKKvEBhs2YXCiA@mail.gmail.com>
 <B6D7DD2C-7F32-40D0-A24B-CE955B33438F@me.com> <CANA9Uk76E6D-nznLF+ij9aoJgbpckKqc5gtUu0p4jfPOWCGWbA@mail.gmail.com>
In-Reply-To: <CANA9Uk76E6D-nznLF+ij9aoJgbpckKqc5gtUu0p4jfPOWCGWbA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 9 Mar 2020 11:17:22 +0100
Message-ID: <CAOi1vP_WNn2eSqwm-9Nvo+Gzv9MUYGmPaMGRpAsd3EKSdHBb3Q@mail.gmail.com>
Subject: Re: [ceph-users] Re: ceph rbd volumes/images IO details
To:     M Ranga Swami Reddy <swamireddy@gmail.com>
Cc:     XuYun <yunxu@me.com>, ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.com>,
        Ceph Community <ceph-community@lists.ceph.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Mar 8, 2020 at 5:13 PM M Ranga Swami Reddy <swamireddy@gmail.com> w=
rote:
>
> Iam using the Luminous 12.2.11 version with prometheus.
>
> On Sun, Mar 8, 2020 at 12:28 PM XuYun <yunxu@me.com> wrote:
>
> > You can enable prometheus module of mgr if you are running Nautilus.
> >
> > > 2020=E5=B9=B43=E6=9C=888=E6=97=A5 =E4=B8=8A=E5=8D=882:15=EF=BC=8CM Ra=
nga Swami Reddy <swamireddy@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Fri, Mar 6, 2020 at 1:06 AM M Ranga Swami Reddy <swamireddy@gmail.=
com
> > >
> > > wrote:
> > >
> > >> Hello,
> > >> Can we get the IOPs of any rbd image/volume?
> > >>
> > >> For ex: I have created volumes via OpenStack Cinder. Want to know
> > >> the IOPs of these volumes.
> > >>
> > >> In general - we can get pool stats, but not seen the per volumes sta=
ts.
> > >>
> > >> Any hint here? Appreciated.

Per image/volume stats are available since nautilus [1].  There is
no automated way to do it in luminous.  Since you are using openstack,
you can probably set up some generic I/O monitoring at instance level
(i.e. external to ceph) and possibly apply disk I/O limits (again at
instance level, enforced in qemu).

[1] https://ceph.io/rbd/new-in-nautilus-rbd-performance-monitoring/

Thanks,

                Ilya
