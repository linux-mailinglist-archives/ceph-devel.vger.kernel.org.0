Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058AD339A5
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 22:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFCUX2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 16:23:28 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38632 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfFCUX2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 16:23:28 -0400
Received: by mail-io1-f66.google.com with SMTP id x24so15452937ion.5
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 13:23:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ePlI70mAS5kOlqlpcTSydALhjf2J/Pb3a+0UI/wk88M=;
        b=MqyIbReaIWcbaFqFjPkAkUiNAmn9RRaPHTQaH1wi2iNq5FXG+F4lEbQ7fS/mkaP1O+
         l4/JJDV9Rv7AIodbXrJDQUvNYus490fpeC5hFEErBRcRFdXVPABR3tgfFjoqlogFkmAx
         VbMEFkeCReh8/DQmyQzwv/ZPr1R2jJTlZeB0dpbCiM9Il8OK7lZF/HaQlRk9tD4d4nT6
         mAIvD8APRSVgUM8C3GW+e9wXaGD9VxMu124hywUlQRF6UXZdtfFakIxsSbyXpZqdBuhB
         6ZUr4JBywVkQnJ50RnoAt85X9tRc/oTrHUPyv97pmI/umdcY/iIgf1belOJJ6xtpTXn9
         Y5Iw==
X-Gm-Message-State: APjAAAVnSg72YdX3EEDBOGnPfDgfqlGnjZRTwUSobtnQz4zMrioiCUt7
        3aJACUR0Y+GmTqGd6YyAbZq3QzUzpCnzNq9Vd43yIg==
X-Google-Smtp-Source: APXvYqx8pe3SlbaQc+RsYKtiPubRF86p0yLeK0jhLrUeOLi8u1Cdhn8tA2uff7ZtgnbkNM5bHw6oCoFXttPBfRb63wk=
X-Received: by 2002:a5d:9282:: with SMTP id s2mr6105174iom.36.1559593407039;
 Mon, 03 Jun 2019 13:23:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com> <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
In-Reply-To: <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 3 Jun 2019 13:22:42 -0700
Message-ID: <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Ilya Dryomov <idryomov@gmail.com>
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

On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> Can we also discuss how useful is allowing to recover a mount after it
> has been blacklisted?  After we fail everything with EIO and throw out
> all dirty state, how many applications would continue working without
> some kind of restart?  And if you are restarting your application, why
> not get a new mount?
>
> IOW what is the use case for introducing a new debugfs knob that isn't
> that much different from umount+mount?

People don't like it when their filesystem refuses to umount, which is
what happens when the kernel client can't reconnect to the MDS right
now. I'm not sure there's a practical way to deal with that besides
some kind of computer admin intervention. (Even if you umount -l, that
by design doesn't reply to syscalls and let the applications exit.)
So it's not that we expect most applications to work, but we need to
give them *something* that isn't a successful return, and we don't
currently do that automatically on a disconnect. (And probably don't
want to?)
