Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D692105D0B
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Nov 2019 00:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKUXI3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 18:08:29 -0500
Received: from mail-qk1-f177.google.com ([209.85.222.177]:36830 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKUXI3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Nov 2019 18:08:29 -0500
Received: by mail-qk1-f177.google.com with SMTP id d13so4694741qko.3
        for <ceph-devel@vger.kernel.org>; Thu, 21 Nov 2019 15:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pXlASiB338hKH02/UHMGEtjuf6HdoxVk5Oxi2Rvp6qQ=;
        b=LNwfKZcl5IKMS6Nt8B0ylsdrmwFYJ/Lg4GSXfXfCsnJbAqKk+Xh+7Sv9Z65YvADdb2
         6aYpvbt+IZzuBYJG0cyD8bcIEjZNNTzZJwu5SkhDnq9P49UxeFX4n0E8gOlmwVM+mI5h
         f0PaqMxCKFo420obkXcmhh+8tEYDrAI4EF9xGwjjB2cjTsNbigaYnSu9dqORUeIZWE8X
         3ncDMUcmyHpUNtWahIzKoGkZQoQ9+F/x4nk1HFjhd6LZW+cDUY+gOoCOyfafeCkggyME
         gqlzryV8tmPTewT9tgnZkHKrQbJ/wWxeWG9aaZXmAa/qigrTw2rZD+Uj7/b3rz+V1fj1
         ayfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pXlASiB338hKH02/UHMGEtjuf6HdoxVk5Oxi2Rvp6qQ=;
        b=JPEFK+6dOiwOy2uKD+MpiY1CnnZ0RCe2cY8uJG1gfV9T7rs5JfH3VgqvJ6CnOwPQgL
         cAWhRFVE5gyWZ5Xn4eUmwCXLao+XL6Iw1mhp1A986Y3n8RKrpWckb3dk+tJrxM8q6OSY
         kKhiBancFmfAO48m4E/DX5Xep4bVANy31szLqS9EDwbJEMjcBH6ov8I0dnEi/8o+BvAY
         5JMTNdH05FJvPk4DU85E0e6AwGWMFb4VxJl/aSRKkwa6M2HszSOBD27yug4kcNBQtii8
         uEFE77BmAbBRVPcMR56yQIPd/DiMnjkYM/3NXwLDUal5+zZW0XWFDCAZmaP2QTcrToNh
         R+eA==
X-Gm-Message-State: APjAAAWd6TCbnvdF/Ayc/6htaODaA9njjuo1DkZWo3nhpmhvz9k6DO85
        BYtONB8smbwqNfb10gpESlxGs3yBGW1SRXZULRM=
X-Google-Smtp-Source: APXvYqy2knYfK2HskhzYkuWcg8DrKGBSe7RL+uxXS7045KYRs8vdPThXpEK/2R4r+qeNI4fdwd5tkTdtw3Rl7LVUAx8=
X-Received: by 2002:a05:620a:302:: with SMTP id s2mr10566531qkm.458.1574377708214;
 Thu, 21 Nov 2019 15:08:28 -0800 (PST)
MIME-Version: 1.0
References: <CAPNbX4TY5Yv31FscT0=Q5GEbFcY7M=y07y7UL9ikPhFxA+wiJw@mail.gmail.com>
 <alpine.DEB.2.21.1911212223110.21478@piezo.novalocal> <b11c2c0a-5d0e-0d63-5a46-d7b8d8bbd413@redhat.com>
 <51ad1b37-bf6b-50ad-d06d-7db0d9d1ad45@redhat.com>
In-Reply-To: <51ad1b37-bf6b-50ad-d06d-7db0d9d1ad45@redhat.com>
From:   Kyle Bader <kyle.bader@gmail.com>
Date:   Thu, 21 Nov 2019 15:08:17 -0800
Message-ID: <CAFMfnwry8a-p-Un0A+-h-rbKA8V=U5zmFdX8VN_fFPpr7pWZpw@mail.gmail.com>
Subject: Re: device class : nvme
To:     Mark Nelson <mnelson@redhat.com>
Cc:     Sage Weil <sage@newdream.net>,
        Muhammad Ahmad <muhammad.ahmad@seagate.com>, dev@ceph.io,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We ssd device class on rook-ceph built clusters on m5 instances
(devices appear as nvme)

On Thu, Nov 21, 2019 at 2:48 PM Mark Nelson <mnelson@redhat.com> wrote:
>
>
> On 11/21/19 4:46 PM, Mark Nelson wrote:
> > On 11/21/19 4:25 PM, Sage Weil wrote:
> >> Adding dev@ceph.io
> >>
> >> On Thu, 21 Nov 2019, Muhammad Ahmad wrote:
> >>> While trying to research how crush maps are used/modified I stumbled
> >>> upon these device classes.
> >>> https://ceph.io/community/new-luminous-crush-device-classes/
> >>>
> >>> I wanted to highlight that having nvme as a separate class will
> >>> eventually break and should be removed.
> >>>
> >>> There is already a push within the industry to consolidate future
> >>> command sets and NVMe will likely be it. In other words, NVMe HDDs are
> >>> not too far off. In fact, the recent October OCP F2F discussed this
> >>> topic in detail.
> >>>
> >>> If the classification is based on performance then command set
> >>> (SATA/SAS/NVMe) is probably not the right classification.
> >> I opened a PR that does this:
> >>
> >>     https://github.com/ceph/ceph/pull/31796
> >>
> >> I can't remember seeing 'nvme' as a device class on any real cluster;
> >> the
> >> exceptoin is my basement one, and I think the only reason it ended up
> >> that
> >> way was because I deployed bluestore *very* early on (with ceph-disk)
> >> and
> >> the is_nvme() detection helper doesn't work with LVM.  That's my
> >> theory at
> >> least.. can anybody with bluestore on NVMe devices confirm? Does anybody
> >> see class 'nvme' devices in their cluster?
> >>
> >> Thanks!
> >> sage
> >>
> >
> > Here's what we've got on the new performance nodes with Intel NVMe
> > drives:
> >
> >
> > ID  CLASS WEIGHT   TYPE NAME
> >  -1       64.00000 root default
> >  -3       64.00000     rack localrack
> >  -2        8.00000         host o03
> >   0   ssd  1.00000             osd.0
> >   1   ssd  1.00000             osd.1
> >   2   ssd  1.00000             osd.2
> >   3   ssd  1.00000             osd.3
> >   4   ssd  1.00000             osd.4
> >   5   ssd  1.00000             osd.5
> >   6   ssd  1.00000             osd.6
> >   7   ssd  1.00000             osd.7
> >
> >
> > Mark
> >
>
> I should probably clarify that this cluster was built with cbt though!
>
>
> Mark
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
