Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076CB339FB
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 23:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfFCVnQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 17:43:16 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34950 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfFCVnP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 17:43:15 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so2244258ioo.2
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 14:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+8WH3UkK58G55NYtmJVNkD8pACe/aZK39tEPB7JRSEs=;
        b=HbmR14zOlTLAZ9V0jVPaAPPAVgAKPnHT9EsUkiO5wpYJPlNkm4kv8/UKJ6EZag5/gd
         nvs/DuuPHen8wDxoZQYvs3DFGatXfR9zrwReh1JOye3uy6mwq85TdHhA6DZ9u9PEkrb0
         r/mkxJ+HEvOczM2nlj+fhRvCFuSxWx05OM1bOtFEUnHiz9Kcn7YV/CIqXbVoj6wdIJIa
         JJOfIY0XG3HCEbrCRA+URP5fbtBhz2SE56ourjT+5Ye5fk5iUb8uaLYDwdHlUhFiot85
         w6HP7zeBLraSBFJiISPxCWCKEJJM1zuif4EpFop3f7+Gdig92I7wzCK7jgQ3L8zT45X6
         rQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+8WH3UkK58G55NYtmJVNkD8pACe/aZK39tEPB7JRSEs=;
        b=Og9nsIESHfMsRVlw93izgzGka+4In6BDx+7/eCcuGACCOhIeszXEhPvekck0t2VmmN
         fQkgb9H7/eXF7gp575hXRYwlKTi9Ha5JHs9S11rqHXDUhrg1j0wqUjUKR9euwehTrcZV
         Yd9/nra8fEmB9b2F8qwsiZjRJi2HUQYDOb7K2J1Ykw6C6ADzGvQ4D0bW0OF43tjHLczJ
         8IxGbvYpzsIb+mvVrjaLPc1dwC0zD7dri9uMUkSnL85xlt6WFdJr61noDGwO9k53dXwX
         Q470xiY0mYq3np3WGX6hpRBr+6QgpCLmc0pAf+ptlMs0UgSvLlcWJpuE1UovpcITdZOH
         y4Zg==
X-Gm-Message-State: APjAAAWvOum77MBYkEjTs+QRYN3kuRSY+s3gi3/zXuBUli4Ly1piYPBT
        AOs8untYy5U8S+To3irL9HI0lyF1jjfldqK/EV+ke0Wn
X-Google-Smtp-Source: APXvYqypTltR6zb8kU81lHrc/i03ieqGZ27mSpRmMQ9VkxzJiwKilHSx8f92Wk86MGUhenBO/FzlD2EpoQfldBgtzfA=
X-Received: by 2002:a6b:7311:: with SMTP id e17mr16801492ioh.112.1559596699280;
 Mon, 03 Jun 2019 14:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com> <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
In-Reply-To: <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Jun 2019 23:18:23 +0200
Message-ID: <CAOi1vP88A7G_7ScstLSNwe-tUZcBUxhK=W5Qdix2tgPEOB9i8g@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 10:23 PM Gregory Farnum <gfarnum@redhat.com> wrote:
>
> On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > Can we also discuss how useful is allowing to recover a mount after it
> > has been blacklisted?  After we fail everything with EIO and throw out
> > all dirty state, how many applications would continue working without
> > some kind of restart?  And if you are restarting your application, why
> > not get a new mount?
> >
> > IOW what is the use case for introducing a new debugfs knob that isn't
> > that much different from umount+mount?
>
> People don't like it when their filesystem refuses to umount, which is
> what happens when the kernel client can't reconnect to the MDS right
> now. I'm not sure there's a practical way to deal with that besides
> some kind of computer admin intervention. (Even if you umount -l, that
> by design doesn't reply to syscalls and let the applications exit.)

Well, that is what I'm saying: if an admin intervention is required
anyway, then why not make it be umount+mount?  That is certainly more
intuitive than an obscure write-only file in debugfs...

We have umount -f, which is there for tearing down a mount that is
unresponsive.  It should be able to deal with a blacklisted mount, if
it can't it's probably a bug.

Thanks,

                Ilya
