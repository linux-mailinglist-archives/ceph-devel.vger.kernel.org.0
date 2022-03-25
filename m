Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360D24E72AA
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Mar 2022 13:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353901AbiCYMEN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Mar 2022 08:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344291AbiCYMEM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Mar 2022 08:04:12 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C012AD4C92
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 05:02:38 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id w123so4106797vkg.7
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 05:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1eUbx1Pdc/s/6DST5Wdsu/HaXlFiszD/xbQXUyI3F/A=;
        b=jiyJOrTBWHo+az//mLN7RlqOP1Ra6k/xQtwL9VIp7Z1NXh2GncanUf7LxuaNJ17WdT
         jB8KG78gdIZstyjHhJCvVBJJsZ4qxBGO1ZP1xc7N3vpTcDwA8iQhHieXjmiQaFM2pzSX
         XZ89Dui4JGHioxwmgip3msewQZ01vMMQMhdRyq97oEUqj70a6rOqrpmliREa4YBj2B0A
         nyg8x7VhQ+BG69KC8rFqMyEdpwXmjMzpi6SfGP3RytvOQCVRyvELZ+E9hdEksC+qPp9f
         qMPSrr9M/LPDRSP0har0Jqh99VxvbXlTUwyiIJm+5k6TMUJrYMxI38cdT8LBQvloM9s3
         WHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1eUbx1Pdc/s/6DST5Wdsu/HaXlFiszD/xbQXUyI3F/A=;
        b=pMIxGxIu3++Ech7iLhtyNoNYuCZXbPhr8LfnFambX925R0qC6S1WfCxjLqeTSnKUtQ
         UyJYiooW/qQlvMcdUQzdHdTdfXHmVvxJxniYembnBlhoYI0YTRG1MDUYrNSetbwRWB3s
         ydL/jHpnh28UIxfcXtd86WhUuWnYjiDkh4TPuNd3ETfn5qGm8GI2MW9qcB990caf698P
         anIFtSf8kq37l5ia0grlfblRXbYksodBa4SW8k67yPuZVRdwcBprj+3AfHye8ejY2kcw
         p4Qk2OQRclVlVKfyXAxo+yMRI52fAvxCOJDx5+gppaWDHF5ysodZep0Sh2iXcYZ7Vhhg
         542w==
X-Gm-Message-State: AOAM532PxkBq88YEY5waFbMP6tg4tbZpqttNzCSSqwmqirKWbDyy9rWk
        quZ6AxPcZk+lIuYyBRYLJR9ijIBCQYoASE3YdXk=
X-Google-Smtp-Source: ABdhPJy1a1HrEoxINOYWV1t11XjPMt8tyOk/LMe3L8/zZxIyRqMNeg8hmbhKZZPRpPjV+D/SNsM8rIJIlNA5vlmCoPY=
X-Received: by 2002:a05:6122:8c8:b0:32a:7010:c581 with SMTP id
 8-20020a05612208c800b0032a7010c581mr4733296vkg.32.1648209757259; Fri, 25 Mar
 2022 05:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <d0a7e3d1-f9ca-994e-fa6e-b730b443346d@cybozu.co.jp>
 <CAOi1vP9SXGRzQF=Thy70QO0NyGjpPBtmCWyF4pfODJNPrWoX0A@mail.gmail.com>
 <f6f40fc0-5154-57ac-c28a-3d58ed15bd77@cybozu.co.jp> <CAOi1vP9zXPek_LKkrT-OvZ0Xa0B=pz90y33TM_CVmsvcH8HPGw@mail.gmail.com>
 <050545f4-ff14-9d18-d323-850e06f61745@cybozu.co.jp> <CAMym5wvL-pKduh8mqyqP6U2u+bLyA15CYaZUHVMc=iV+hALwxw@mail.gmail.com>
In-Reply-To: <CAMym5wvL-pKduh8mqyqP6U2u+bLyA15CYaZUHVMc=iV+hALwxw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 25 Mar 2022 13:03:11 +0100
Message-ID: <CAOi1vP-xkO7RNqPtnABAQ8491b2G5xhoVZAcW4sXFSQEzb4qQA@mail.gmail.com>
Subject: Re: [PATCH v2] libceph: print fsid and client gid with mon id and osd id
To:     Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc:     Daichi Mukai <daichi-mukai@cybozu.co.jp>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Mar 25, 2022 at 3:54 AM Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
>
> Hi Ilya
>
> > >>> Hi Daichi,
> > >>>
> > >>> I would suggest two things:
> > >>>
> > >>> 1) Leave dout messages alone for now.  They aren't shown by default and
> > >>>      are there for developers to do debugging.  In that setting, multiple
> > >>>      clusters or client instances should be rare.
> > >>
> > >> Sure, I'll leave dout messages alone.
> > >>
> > >>> 2) For pr_info/pr_warn/etc messages, make the format consistent and
> > >>>      more grepable, e.g.
> > >>>
> > >>>        libceph (<fsid> <gid>): <message>
> > >>>
> > >>>        libceph (ef1ab157-688c-483b-a94d-0aeec9ca44e0 4181): osd10 down
> > >>>
> > >>>      as I suggested earlier.  Sometimes printing just the fsid, sometimes
> > >>>      the fsid and the gid and sometimes none is undesirable.
> > >>
> > >> Let me confirm two points:
> > >>
> > >> - For consistency, should all pr_info/pr_warn/etc messages in libceph
> > >>     uses format with fsid and gid? Or does your suggestion means messages
> > >>     with osd or mon id (i.e. messages which I had edited in this patch)
> > >>     should have consistent format?
> > >
> > > Definitely not all messages.  I'd start with those that are most common
> > > and that _you_ think are important to distinguish between.  Whether mon
> > > or osd id is included is probably irrelevant.
> > >
> > > The reason I'm deferring to you here is that I haven't seen this come
> > > up as an issue.  99% of users would connect to a single Ceph cluster
> > > (which means a single fsid) with a single libceph instance (which means
> > > a single gid).
> > >
> > > But consistency is very important, so IMO a particular message should
> > > either be not touched at all or be converted to a consistent format.
> > >
> > >>
> > >> - What should be displayed if fsid or gid cannot be obtained? For example,
> > >>     we may not know fsid yet when establishing session with mon. Also,
> > >>     decode_new_up_state_weight() outputs message like "osd10 down" etc, but
> > >>     it seems not easy to get client gid within this function. This is why
> > >>     there are sometimes fsid only and sometimes gid only and sometimes both
> > >>     in my patch.
> > >
> > > For when the mon session is being established, do nothing (i.e.
> > > leave existing messages as is).  For after the fsid and gid become
> > > known, either convert to a consistent format with both fsid and gid or
> > > do nothing if the message isn't important.  If this causes too much
> > > code churn because of additional parameters being passed around, we may
> > > need to reconsider whether this change is worth it at all.
> >
> > Thank you for your kind comments. They are very helpful for me. I'll think
> > again about when fsid and gid in the logs are useful.
> >
> > Daichi
>
> There are multiple Ceph clusters in our system. A cluster provides RBD
> on top of HDD
> and another cluster provides RBD on top of SSD. All Ceph(more
> precisely, Rook/Ceph)
> clusters are in one Kubernetes cluster. Many types of
> applications(Pods) can co-exist
> for each node and there is not so special that an application consumes RBD(SSD)
> and another application consumes RBD(HDD) are on the same node. In
> this case, it's
> very useful to distinguish from which cluster each kernel message comes.
>
> We've already encountered trouble that could have been solved earlier
> if this fix is applied.
> We encountered slow I/Os in an application using RBD(HDD) and found
> that there were
> some "OSD n down/up" messages. Then we took some time to confirm whether these
> messages were related to the problem because there was another
> application using RBD(SSD)
> in the same node and it's hard to know these messages were about
> RBD(HDD) cluster.
>
> What we really need for now is to clear from which "OSD n down/up"
> messages come.
> So, how about adding "libceph (<fsid> <gid>):" prefix to these two
> messages and don't touch
> any other messages? Does it make sense?

Hi Satoru,

Sure, starting with just these two messages is fine with me but if
I were you I would also cover the other three similar messages that
may be reported while processing new osdmaps:

    osd<id> down
    osd<id> up

    +

    osd<id> weight ...
    osd<id> primary-affinity ...
    osd<id> does not exist

Thanks,

                Ilya
