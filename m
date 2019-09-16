Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81735B356F
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Sep 2019 09:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfIPHSV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Sep 2019 03:18:21 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45326 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfIPHSU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Sep 2019 03:18:20 -0400
Received: by mail-oi1-f194.google.com with SMTP id o205so7418286oib.12
        for <ceph-devel@vger.kernel.org>; Mon, 16 Sep 2019 00:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/cXS4nOP+K32sh97htL6yq3gRgtBGjGV5tJLHdRJQ7I=;
        b=EjlI7XGoNFKdU1QQSH+mD9rc07KwXieS/p9dfCY14Qi+oLZKxgqtqlrqT8RPNdURkO
         l5R/2KkdynNS4goZXayIKvdPKwNyRjXtjgSKyhUnp1HIrU7IM+B5/fgA4s83VB1iqnT1
         oAWhOP9hIorngsW8GpgfyOe2uVEzQRAhM0mVKHDOqzP0bzzNaKf+Gr+LKuhCs8G6eKHN
         iSInYjM64HwU1UqD7c9dwX6YkqgbK2/H3z+96ujBIQLq+speq8DwpSfqUZCX5cwEyDtj
         q550lamehKedntWjrP06GV7pojTeaUB/VDo0iMuDKo8of0kogxd3y+ZF2kire4RJvbcC
         difg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/cXS4nOP+K32sh97htL6yq3gRgtBGjGV5tJLHdRJQ7I=;
        b=YB15enx0cpAv5HrQE/XDqskj9+gIK7A8wxf6BIFEJWI6jqsj2LVQHvU4mvXScjhogy
         0Zlnc6Ws/vc2FruRBJmAzRglOslRATgErWFY16eiq5Zgo5PW6kgP+rgzIaCPEvkoiwdo
         nz7YiXern/8BIEV544ODJE2TdpwjuSX0tE1Gv5g/qecqTMG+/sJEeYLvKM7zRJwZS6WZ
         l1lKwo9FePPbYfFDRRkfCWAlF/FBXMy1d/gZ2hyPQ4yxLRkSZGB3gVhZL6euc9JiaMIZ
         YG7C9NcjPo7D3Y0RRYd+PqfI9wW4+7x7PjwyoZT412pyJZMSd5mxCG3CpiNeiyvBdVCR
         +olg==
X-Gm-Message-State: APjAAAV3SQvYiJFqgF9/HLwb278AgC7s5mseWPDdvCHA8LaICFEv9Fsp
        QEr/wkBSMQB0NTks5+mmDKoFIDjqrP/nqXy7wKU=
X-Google-Smtp-Source: APXvYqyTD8N4259Qx5UQ0KGm/yPmVhEFaT5bAvL19p4j0hvgOHCmUdqhd2rLk/BRn7KLohKakC8hsvHJn3MFDBWuAU0=
X-Received: by 2002:aca:d642:: with SMTP id n63mr12348511oig.168.1568618300290;
 Mon, 16 Sep 2019 00:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <1568083391-920-1-git-send-email-simon29rock@gmail.com>
 <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
 <CAJ4mKGbY+veWdLv588Hz4mQidz5ofiGemOQ2Nwx_M6XN0WXGJw@mail.gmail.com>
 <dc75c171278e4dd1fc00c20b3a9843bb412901ac.camel@kernel.org>
 <CAAM7YAmdccvHiOB6+qk5MOLX5u3NrTa4MrUOH_MG+VD=_TV3cA@mail.gmail.com> <14f39bfc51e730384f56a21bafa8c97ac8b52fa0.camel@kernel.org>
In-Reply-To: <14f39bfc51e730384f56a21bafa8c97ac8b52fa0.camel@kernel.org>
From:   simon gao <simon29rock@gmail.com>
Date:   Mon, 16 Sep 2019 15:18:09 +0800
Message-ID: <CAGR3woVAJjbrEX3mLja_Q8ag4tVm9jE3dBiq5xSeBJCys6Zh6g@mail.gmail.com>
Subject: Re: [PATCH] ceph: add mount opt, always_auth
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff
Yes.
If there are too many files in a cluster (100 million levels) far more
than cache of a single mds, fixed inodes to special mds, and prevents
other mds from loading these inodes, which can achieve better results.
This problem is particularly prominent on mds0.
This problem is similar to flushcache. Good ratio of ssh and hdd can
get better results.
Removing the duplicate inodes is equivalent to increasing the total
amount of cache. I think.

thanks
gaoyu

>
> On Fri, 2019-09-13 at 10:08 +0800, Yan, Zheng wrote:
> > On Thu, Sep 12, 2019 at 6:21 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Wed, 2019-09-11 at 11:30 -0700, Gregory Farnum wrote:
> > > > On Tue, Sep 10, 2019 at 3:11 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > I've no particular objection here, but I'd prefer Greg's ack before we
> > > > > merge it, since he raised earlier concerns.
> > > >
> > > > You have my acked-by in light of Zheng's comments elsewhere and the
> > > > evidence that this actually works in some scenarios.
> > > >
> > > > Might be nice to at least get far enough to generate tickets based on
> > > > your questions in the other thread, though:
> > > >
> > >
> > > I'm not sold yet.
> > >
> > > Why is this something the client should have to worry about at all? Can
> > > we do something on the MDS to better handle this situation? This really
> > > feels like we're exposing an implementation detail via mount option.
> > >
> >
> > I think we can.  make mds return empty DirStat::dist in request reply
> >
>
> I guess that'd make the client think that it wasn't replicated?
>
> Under what conditions would you have it return that in the reply? Should
> we be looking to have the MDS favor forwarding over replication more (as
> Greg seems to be suggesting)?
>
> Note too that I'm not opposed to adding some sort of mitigation for this
> problem if needed to help with code that's in the field, but I'd prefer
> to address the root cause if we can so the workaround may not be needed
> in the future.
>
> Mount options are harder to deprecate since they'll be in docs forever,
> and they are necessarily per-vfsmount. If you do need this, would the
> switch be more appropriate as a kernel module parameter instead?
>
> > > At a bare minimum, if we take this, I'd like to see some documentation.
> > > When should a user decide to turn this on or off? There are no
> > > guidelines to the use of this thing so far.
> > >
> > >
> > > > On Wed, Sep 11, 2019 at 9:26 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > In an ideal world, what should happen in this case? Should we be
> > > > > changing MDS policy to forward the request in this situation?
> > > > >
> > > > > This mount option seems like it's exposing something that is really an
> > > > > internal implementation detail to the admin. That might be justified,
> > > > > but I'm unclear on why we don't expect more saner behavior from the MDS
> > > > > on this?
> > > >
> > > > I think partly it's that early designs underestimated the cost of
> > > > replication and overestimated its utility, but I also thought forwards
> > > > were supposed to happen more often than replication so I'm curious why
> > > > it's apparently not doing that.
> > > > -Greg
> > >
> > > --
> > > Jeff Layton <jlayton@kernel.org>
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
>
