Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53119196DC8
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Mar 2020 16:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgC2OAX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Mar 2020 10:00:23 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45373 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgC2OAX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Mar 2020 10:00:23 -0400
Received: by mail-lf1-f65.google.com with SMTP id v4so11652909lfo.12
        for <ceph-devel@vger.kernel.org>; Sun, 29 Mar 2020 07:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwud2fBt9zPg80cfeUIGvN5KfssFMp3A2QN4+ZzV0FI=;
        b=R0m2jcwBLoumdNAH+1jA6HpN2mj0scNAvhMBmVWOVto892HTYFxBZCfbwYWwm9fcCh
         pySHnp9FvZ6BZZia/YiPkR4dLeHwyMQlBG0bIMNqQgQoU6qKb+e3K8x5NR3+xdx/HWtB
         UpyEUEA0gKYBRvReyZb9M4iXgC31wjkpz6/ReVN1IZc7uIV53ojHX1tPzfH7K5woUODR
         GjOfjC8ND6S0LetG6Opof+Cz7Xbnu2u2Ih/nTNkXV5wlIXOK0TmHjZMzsagPkN8z6J3S
         k+FOIaXv4KwKNNy/jpcABdUzfWWGIlrDBiD+/zRaCVY79Xmbmr/cnGUusT623roh/XXy
         tH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwud2fBt9zPg80cfeUIGvN5KfssFMp3A2QN4+ZzV0FI=;
        b=jT5d49g2W7CSBmVmN/sroSwlHTE1CTBHvIiynGdiT2Q4usXyTIII9FZaZAw420ko1k
         iRESxr5GzLt2/OA3jpzsUmSkPJygggptHRev0Q1YfaPr8yDm23VPU+h9QAFTR0q7/sWX
         HrBuDOob02Hdo8buZDRY1cJgu/jIUnGS+OkLoPF9KO/QxnaNypfV/qXricNLwpxSkLms
         EwLc4tiL1dJJo3IygYPDW9ySAELjibwPJz8w0uBNK//pxH4ErXmqtDpNcpfMSrzyIWf8
         qMPZo2JNzycGZQet60kfp2skpco3vfxaUF8aFw+hQx3Z3YNaQzpriIaWLsbrP3quvom1
         ty5g==
X-Gm-Message-State: AGi0PuaM6PsYTYK6rt+5Oc60hP3/DA0tKZE2vF3ja/f3aklCikzWXpz0
        NjHMsTsy6cXHlosb4JdG6PjVe5OqoQUmck5+cXQ=
X-Google-Smtp-Source: APiQypLyg8koogtmKpwhV4D4myZ1ffdpBXc86HE1lr9TW+vos0/RIUy2TRIqLY+C1rbTOG7qdIXgZqe/OhCFfev+bnY=
X-Received: by 2002:a19:ad47:: with SMTP id s7mr5434523lfd.165.1585490421252;
 Sun, 29 Mar 2020 07:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <878sjqc79i.fsf@suse.com> <alpine.DEB.2.21.2003271410190.4773@piezo.novalocal>
 <CAPPYiwpOOAnNwfPiFMx2zxj7Eh0DCUG+zfALp+8sJSLENDN-Og@mail.gmail.com>
In-Reply-To: <CAPPYiwpOOAnNwfPiFMx2zxj7Eh0DCUG+zfALp+8sJSLENDN-Og@mail.gmail.com>
From:   kefu chai <tchaikov@gmail.com>
Date:   Sun, 29 Mar 2020 22:00:10 +0800
Message-ID: <CAJE9aOMsBp3xq2Ed1UYyBH0On2uOy1_ED_o4_niKE-Mmb8BcHQ@mail.gmail.com>
Subject: Re: [ceph-users] Re: v15.2.0 Octopus released
To:     Mazzystr <mazzystr@gmail.com>
Cc:     Sage Weil <sage@newdream.net>, ceph-announce@ceph.io,
        ceph-users@ceph.io, dev <dev@ceph.io>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Mar 28, 2020 at 1:29 AM Mazzystr <mazzystr@gmail.com> wrote:
>
> What about the missing dependencies for octopus on el8?  (looking at yoooou
> ceph-mgr!)

FWIW, leveldb for el8 is pending on review at
https://bodhi.fedoraproject.org/updates/FEDORA-EPEL-2020-3171aba6be,
if you could help test it. that'd be great!

>
> On Fri, Mar 27, 2020 at 7:15 AM Sage Weil <sage@newdream.net> wrote:
>
> > One word of caution: there is one known upgrade issue if you
> >
> >  - upgrade from luminous to nautilus, and then
> >  - run nautilus for a very short period of time (hours), and then
> >  - upgrade from nautilus to octopus
> >
> > that prevents OSDs from starting.  We have a fix that will be in 15.2.1,
> > but until that is out, I would recommend against the double-upgrade.  If
> > you have been running nautilus for a while (days) you should be fine.
> >
> > sage
> >
> >
> > https://tracker.ceph.com/issues/44770
> > _______________________________________________
> > ceph-users mailing list -- ceph-users@ceph.io
> > To unsubscribe send an email to ceph-users-leave@ceph.io
> >
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io



-- 
Regards
Kefu Chai
