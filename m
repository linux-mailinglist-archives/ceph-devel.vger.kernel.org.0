Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1EA7A3E6
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2019 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfG3JUZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jul 2019 05:20:25 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:38182 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbfG3JUZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jul 2019 05:20:25 -0400
Received: by mail-ot1-f41.google.com with SMTP id d17so65598582oth.5
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2019 02:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RSha2djFRdlNL8qQLyzKbk2AYjvCREhjMCRE6C7Axr4=;
        b=uCr+W8FTJxz6N7d5Da71YvBBNnHFf4veRzLK7ZCADy+KgUtJI/ZHy/s20Ch3t/dG8b
         MWI8FXbQ3pKpqrIkcRFzdc9hGPlNXNXHnEut6WYt961bxSsNOu/vx5jBjwfXv91Hfee7
         srJUtRvWvvkTQ/wmZTPJvYqhUggz+wwpgbera3j78NIaSObfEOUS5AGKUwhN17AjkGbB
         VR6ZO/+pJntVKBy8lGBupa4LHzqeZNG1EPUyZ4aBXahJvsSwUzsXt3vLffrrwZ/Qtbad
         /FUum49KlZa9sY8B+sivhLnIHfjKhvW7Ukz7q9GNT7wxXf9ZDN1EtMRoMtrXU7uVqGs3
         /hrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RSha2djFRdlNL8qQLyzKbk2AYjvCREhjMCRE6C7Axr4=;
        b=i5KjHNdXwgJPv6Way1WzfydBhf8q56cVEHa5aEXSnfhZRJwncCOC0HqOXdMw6CE0bq
         UcoJwYvsoqD8Q52x27Sby8I99G5opgNVMsNem9F+8oRAK5yukVrHrT/6bzQGo6ZZdBFt
         C5MlVHBJJ/P6m/Tonbl/DWZPUUXqJz7QxAjMlioP4m/Axrgya88+p0XLvhM0kFdTqyPt
         Aax+8tOu6D4cMoNKDC+rTLqBpGvVOZDEhZh23QTyF64NUZohHvFuLrmjkrpornnKMllU
         lAMLf56mbG4TKwgUev9sjS3qOv4zxynhSWwvYOpadXWJ1tk48ZRkRgGUISYqSpVPxGfM
         K5Yg==
X-Gm-Message-State: APjAAAV2VBk+owkPlteMjysR76Nch/541ZizUw+L1DtUItW0iT6Ajpuq
        jqjtaw3k2JcM+ynKWfNlFI+sKOrfVgS08/PkfskDohwl
X-Google-Smtp-Source: APXvYqykQTIze4oYmQO742dHvSePM8kLh85OdrdXZE9Z9lJy32nukiw/DU3KBto+rreIu7Y2FiKhvhKmApQxSckX3rk=
X-Received: by 2002:a05:6830:18a:: with SMTP id q10mr81130399ota.114.1564478424191;
 Tue, 30 Jul 2019 02:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
 <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
 <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com> <CAOi1vP-6Xd_jrnRf-Q7qL0SKUQ3kXHuKfOUmx_uYqQEX6R=PJQ@mail.gmail.com>
In-Reply-To: <CAOi1vP-6Xd_jrnRf-Q7qL0SKUQ3kXHuKfOUmx_uYqQEX6R=PJQ@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Tue, 30 Jul 2019 17:20:09 +0800
Message-ID: <CAKQB+fsCpkWf=OfVPiQ8Fq159g+X7v33fvTV85pwUErUzA=dzA@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Ilya,

On Mon, 29 Jul 2019 at 16:42, Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 11:23 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> >
> > Some additional information are provided as below:
> >
> > I tried to restart the active MDS, and after the standby MDS took
> > over, there is no client session recorded in the output of `ceph
> > daemon mds.xxx session ls`.  When I restarted the OSD.13 daemon, the
> > stuck write op finished immediately.  Thanks.
>
> So it happened again with the same OSD?  Did you see this with other
> OSDs?

Yes.  The issue always happened on the same OSD from previous
experience.  However, it did happen with other OSD on other node from
the Cephfs kernel client's point of view.

>
> Try enabling some logging on osd.13 since this seems to be a recurring
> issue.  At least "debug ms = 1" so we can see whether it ever sends the
> reply to the original op (i.e. prior to restart).

Get it, I will raise the debug level to retrive more logs for further
investigateion.

>
> Also, take note of the epoch in osdc output:
>
> 36      osd13   ... e327 ...
>
> Does "ceph osd dump" show the same epoch when things are stuck?
>

Unfortunately, the environment was gone.  But from the logs captured
before, the epoch seems to be consistent between client and ceph
cluster when thing are stuck, right?

2019-07-26 12:24:08.475 7f06efebc700  0 log_channel(cluster) log [DBG]
: osdmap e306: 15 total, 15 up, 15 in

BTW, logs of OSD.13 and dynamic debug kernel logs of libceph captured
on the stuck node are provided in
https://drive.google.com/drive/folders/1gYksDbCecisWtP05HEoSxevDK8sywKv6?usp=sharing.
I deeply appreciate your kindly help!

- Jerry

> Thanks,
>
>                 Ilya
