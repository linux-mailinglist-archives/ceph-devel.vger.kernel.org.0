Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81C376A7A
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2019 15:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387952AbfGZN7N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Jul 2019 09:59:13 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:38283 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387852AbfGZN7N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Jul 2019 09:59:13 -0400
Received: by mail-ed1-f44.google.com with SMTP id r12so18570995edo.5
        for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2019 06:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=OoxAzYMSQLkm6WKbmXgBU/1wDUYEvvQ9twGe/iKrNKg=;
        b=T4N6bz5zLUo0BVGBqAxIqjVZQFBoDUlkUtbz/AFG/zGO6ymWbISJV9OvGgB9A3L6wq
         O2gvNqGxjO7/CD4vqT3dxyEspUWkFq1evVuAKGRo4l0dlMMc89V1YIlPXusBhfkZKzaJ
         eHNrTdhNqbOKg/MQyHzQ57kKHEIJxPJ6KujbyPzfZbR3W1gpZBnDER/ve9lJ2qQDhZvQ
         XLndyXNmWLiv9bGZ3pg4+QTMBUxeYuYStRhxPRwAa18nC63uyH3mIIiMlBKEVVbbgD/x
         Cieh+x7awdYlPgkOGq8spGBkPqdb0PUP08lem5ifQA7xgQG8/sms05dBHe8iDZXuKoA/
         3Ccw==
X-Gm-Message-State: APjAAAXPIOWAm1JTlud37fzy0KP5xKiM4McULeJ21UVlqD5fwiZufIOe
        /cqpvZDXKRe7biMpB37jHYLL9tbSHd5C9E8m7O2NwQ==
X-Google-Smtp-Source: APXvYqyIZYwAP0QrjmAjGAGe6XLcsRm5lu+ugDM4yMbD2n2zIKWDmaUI1xIQV05RLtcpc28C+eb2DjAjlDJ3NfgH24s=
X-Received: by 2002:a17:906:cce9:: with SMTP id ot41mr44088523ejb.196.1564149551166;
 Fri, 26 Jul 2019 06:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAEbG6hG7dAhg=Z9JUKcCCTOEPyXZ6cZcS=jar7SeL-5VTcqEgA@mail.gmail.com>
 <20190726093147.GA31242@gmail.com> <CAEbG6hFgvWFMgaYHRRtZdth-OkJ7ib4vWxf__b7QvGPd1rF6Qg@mail.gmail.com>
 <20190726132546.GA6825@gmail.com>
In-Reply-To: <20190726132546.GA6825@gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Fri, 26 Jul 2019 09:58:59 -0400
Message-ID: <CA+aFP1BwL73Drgz+9Tezw6TwuUug-ibR+nw_5N3cEKdvj1SPQQ@mail.gmail.com>
Subject: Re: [ceph-users] Error in ceph rbd mirroring(rbd::mirror::InstanceWatcher:
 C_NotifyInstanceRequestfinish: resending after timeout)
To:     Mykola Golub <to.my.trociny@gmail.com>
Cc:     Ajitha Robert <ajitharobert01@gmail.com>,
        ceph-users <ceph-users@lists.ceph.com>,
        ceph-users <ceph-users@ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 26, 2019 at 9:26 AM Mykola Golub <to.my.trociny@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 04:40:35PM +0530, Ajitha Robert wrote:
> > Thank you for the clarification.
> >
> > But i was trying with openstack-cinder.. when i load some data into the
> > volume around 50gb, the image sync will stop by 5 % or something within
> > 15%...  What could be the reason?
>
> I suppose you see image sync stop in mirror status output? Could you
> please provide an example? And I suppose you don't see any other
> messages in rbd-mirror log apart from what you have already posted?
> Depending on configuration rbd-mirror might log in several logs. Could
> you please try to find all its logs? `lsof |grep 'rbd-mirror.*log'`
> may be useful for this.
>
> BTW, what rbd-mirror version are you running?

From the previous thread a few days ago (not sure why a new thread was
started on this same topic), to me it sounded like one or more OSDs
isn't reachable from the secondary site:

> > Scenario 2:
> > but when i create a 50gb volume with another glance image. Volume  get created. and in the backend i could see the rbd images both in primary and secondary
> >
> > From rbd mirror image status i found secondary cluster starts copying , and syncing was struck at around 14 %... It will be in 14 % .. no progress at all. should I set any parameters for this like timeout??
> >
> > I manually checked rbd --cluster primary object-map check <object-name>..  No results came for the objects and the command was in hanging.. Thats why got worried on the failed to map object key log. I couldnt even rebuild the object map.

> It sounds like one or more of your primary OSDs are not reachable from
> the secondary site. If you run w/ "debug rbd-mirror = 20" and "debug
> rbd = 20", you should be able to see the last object it attempted to
> copy. From that, you could use "ceph osd map" to figure out the
> primary OSD for that object.



> --
> Mykola Golub
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com



--
Jason
