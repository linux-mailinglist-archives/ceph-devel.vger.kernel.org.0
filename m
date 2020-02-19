Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09AAB164354
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 12:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgBSL1d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 06:27:33 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38355 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgBSL1d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 06:27:33 -0500
Received: by mail-io1-f67.google.com with SMTP id s24so157819iog.5
        for <ceph-devel@vger.kernel.org>; Wed, 19 Feb 2020 03:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVRtI9sWrkLrcSAF8ubBiVkweLW4+9dK4ygbfdLiRWg=;
        b=TWs21C55Nbk7vduwNqvWXy3A4uHMsknP8m6BpmZTYjq7djRgL6PabBIMy9Nv2ME5bw
         jFgLwK+eCuFC2l74PUmiQZOl9WniIvLA6esyEkl5fpQYvZHs14eeqeo0Na13rHOPuf6a
         +bGCWYTK/6AOWelmst4pfIoK4VpUWfRUsQ/DIq6kPfhP6o0PyraFeYiOBMj2aH/IjOV2
         BsRFaV+RyfSvq30CKUQhLYuBlTTf9F5vEKQRSyJWBLfmPTLIF4oL639NKchorrArGKty
         3MluEc9yrW7EKdB+3vfKe+50F0fHEmutf4iR4ntdIlPruGlkiHS8/e++ChfYb2P0vfHa
         1F/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVRtI9sWrkLrcSAF8ubBiVkweLW4+9dK4ygbfdLiRWg=;
        b=Qudlp1MZWOPb4HBsTFQXmqTkWzOuK+yJz+sXF3sJ9JOTpccQ+172g3qextHA84bnsb
         uNIoJwZxWrb1GtdaSJAjSioEENZ0WWmwkyScm3LY2K2tiLYhDvRanSnSsrx+AVEWmZvP
         h/URrm+EWM9o1Wy6Va9jvWRbnIa6IszA8bOf1oYJFgf1utj47DKMoUm6HV+jvaa/dLni
         AcUY+eJutzgmNDIGR/TSxLfMkf+F0VkmOfIDDM64IozXUroIaaV7A0LfUt7S22NfRmzx
         LoQPjsZYpd7sOayf40IX0+0C4qboppj/Rug6DXQ51CqqWC3maodtRc6Svfs0AtovciTb
         KNNQ==
X-Gm-Message-State: APjAAAVZT5e5R2Chf65MfZdr8Q/f+p9DrUaLAl4gBpHFk+dK+debHOJS
        b3MUCJrz6aR60B9qw+ElcuY7RZ2NKjaLiqgWUQKiDORWISw=
X-Google-Smtp-Source: APXvYqxzUFs9tm1IqVl1xETXcTU8wETv0BuV9U7QK5tOCyd0BHU+TuWA/CVm+/KO6sZUNu/OOEjU1u3+2bXpMB7A/50=
X-Received: by 2002:a02:334f:: with SMTP id k15mr4865219jak.96.1582111652995;
 Wed, 19 Feb 2020 03:27:32 -0800 (PST)
MIME-Version: 1.0
References: <23e2b9a7-5ff6-1f07-ff03-08abcbf1457f@redhat.com>
 <CAOi1vP8b1aCph3NkAENEtAKfPDa8J03cNxwOZ+KSn1-te=6g0w@mail.gmail.com> <bed8db55-50e1-a787-c9d4-a7c0f3c6c9d2@redhat.com>
In-Reply-To: <bed8db55-50e1-a787-c9d4-a7c0f3c6c9d2@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Feb 2020 12:27:59 +0100
Message-ID: <CAOi1vP_=t+ppv2Ob1O44-zQz69Y5au2G+5XHvqQ8vvxLUee_2g@mail.gmail.com>
Subject: Re: BUG: ceph_inode_cachep and ceph_dentry_cachep caches are not
 clean when destroying
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 19, 2020 at 12:01 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/2/19 18:53, Ilya Dryomov wrote:
> > On Wed, Feb 19, 2020 at 10:39 AM Xiubo Li <xiubli@redhat.com> wrote:
> >> Hi Jeff, Ilya and all
> >>
> >> I hit this call traces by running some test cases when unmounting the fs
> >> mount points.
> >>
> >> It seems there still have some inodes or dentries are not destroyed.
> >>
> >> Will this be a problem ? Any idea ?
> > Hi Xiubo,
> >
> > Of course it is a problem ;)
> >
> > These are all in ceph_inode_info and ceph_dentry_info caches, but
> > I see traces of rbd mappings as well.  Could you please share your
> > test cases?  How are you unloading modules?
>
> I am not sure exactly in which one, mostly I was running the following
> commands.
>
> 1, ./bin/rbd map share -o mount_timeout=30
>
> 2, ./bin/rbd unmap share
>
> 3, ./bin/mount.ceph :/ /mnt/cephfs/
>
> 4, `for i in {0..1000}; do mkdir /mnt/cephfs/dir$0; done` and `for i in
> {0..1000}; do rm -rf /mnt/cephfs/dir$0; done`
>
> 5, umount /mnt/cephfs/
>
> 6, rmmod ceph; rmmod rbd; rmmod libceph
>
> This it seems none business with the rbd mappings.

Is this on more or less plain upstream or with async unlink and
possibly other filesystem patches applied?

Thanks,

                Ilya
