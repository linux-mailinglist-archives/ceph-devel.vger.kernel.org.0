Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7433A4C
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 23:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFCVxU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 17:53:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44029 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFCVxU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 17:53:20 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so1495588qka.10
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 14:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0o432tXtqoI4ZJthCfEDPNcxplWJ0kDHGBxGoWUBnMQ=;
        b=lQmSdsquGN3Ar9URPaWsKU+XFkLMm3J2kgz+a/7/+cZ4zNvrQfSnJxe6jCqffWSMBW
         f6nymFblSLioz/mZWXr2CLUe/EqHI+iGHum4yhDEy2bB4zy91gWEnCAAkR5BJjJe5/Gm
         D1iIatfwbT22fiWyqYY3Jgm8zWECiHy5ICWj8cDv0K1yqHO9OJRmbCF5PU9d64Qrv20w
         7TVp/3nTXYEDbqJdGkIIIqaCR7abZqrFoujDosZSpoFiVMjZecax0T86T6aSB/k+NfT0
         /j1jWfByHULSKuxDO4AQF14FO0P7tiESuao0K7KEnT6aIjhKdap4mbpSgHaSVdpfQUVe
         c5HA==
X-Gm-Message-State: APjAAAXe9kAu/A6L6xXNQ8e6r4oM6O4BGJPoO5//v1UGV5qxfOgL7xKB
        6pjQFcd7/qZqRT8Fn7gl4wKPhvboSexmsyPeUwbjJGg6
X-Google-Smtp-Source: APXvYqzW8/vtDEXo0QbC4fivwTd17wX0iP3FdJdIOxCpjyeU36NIhkfW7OQImafEmqzmwPqR2O994XDZHRhtW6tyS40=
X-Received: by 2002:a37:a743:: with SMTP id q64mr23580725qke.236.1559595946107;
 Mon, 03 Jun 2019 14:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com> <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
In-Reply-To: <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 3 Jun 2019 14:05:19 -0700
Message-ID: <CA+2bHPboGYSY82Mh73qdSREZhzve72s4GgDVXqhdrdpW9YbC7Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 1:24 PM Gregory Farnum <gfarnum@redhat.com> wrote:
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
> some kind of computer admin intervention.

Furthermore, there are often many applications using the mount (even
with containers) and it's not a sustainable position that any
network/client/cephfs hiccup requires a remount. Also, an application
that fails because of EIO is easy to deal with a layer above but a
remount usually requires grump admin intervention.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
