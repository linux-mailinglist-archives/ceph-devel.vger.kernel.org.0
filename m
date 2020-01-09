Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66B7135FE1
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 18:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbgAIRxp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 12:53:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45123 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728653AbgAIRxo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jan 2020 12:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578592423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kZdCimPJvfyDZao0S1toHR+k+CxKhlwT5duYLu2TeyM=;
        b=KkXBzmPo3g0dpH/mSeT0urpny4PIyxwamZy4OhTGZZ0MQNEp2t2h13MOysu9Ec58knAGV4
        0do+3wD8skesxf+UdxztYg9YEJ4ayRzWBG/zKqg+vAtOEKR11HvtDU4zKDT5ZDQp/oXLMQ
        rYwVhYzvMDKqLNaelQKW4KabsWBQo88=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-ZlJV4LCPMk6hdYC5lF2Z3A-1; Thu, 09 Jan 2020 12:53:42 -0500
X-MC-Unique: ZlJV4LCPMk6hdYC5lF2Z3A-1
Received: by mail-qk1-f200.google.com with SMTP id 194so4648639qkh.18
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jan 2020 09:53:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZdCimPJvfyDZao0S1toHR+k+CxKhlwT5duYLu2TeyM=;
        b=QuVyBU/HdoF0alBNGh/CkgXAF8APqZtxbMg1jXf/dwb7TE5lhEGrXCtzl8Yu960j7Y
         krs5TLbWBU6RMX1sMzhAc0OvLwmyXKeaH0U8+oWaMUkuuzbxOP5/AMCFMt7Qiz4dTPI5
         EXl1NgJZrJJjCf1YXWPLqBB72lr6oCCtZHP7Yd/dFS4VyYfPzG2o/5gYvmQ9tu0bKe3h
         OXh6Q5btWOaFxEJA6UhC0RpzA+W1suEU58W6zsVAAEdP5ny75U9BNHWcT1J3pg8kUozx
         ckRJovP/oYEzYhH3AlYUjlu4/h2S6KcLxwbyQH8v9Cnb42yqdiFQalr8uUINx7DDCglH
         9kZg==
X-Gm-Message-State: APjAAAW5QOhRte4wr5tGt0y//PEmv2kkQq4ny97qAdE4Y7uFwl3LVGd8
        X9E+DrS4w7RW6efN4BN6mcuDhcGd4mEMl7UKQi3xrdVvPtd3dqsWGTyYHFY72o9W38Y86429wqF
        liEscud9c+XVjGoBuGYJqg9UbxFArbF3fa5BqFg==
X-Received: by 2002:a0c:e8c7:: with SMTP id m7mr10018442qvo.128.1578592422103;
        Thu, 09 Jan 2020 09:53:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqyLxuODiOQkPN9SEdqSm+kM3bIdKKrSrVVHHmSzwUEnAlu1ud7jTL/n+UD9Zwv/1cecohciNi9hPhQWP1keMhQ=
X-Received: by 2002:a0c:e8c7:: with SMTP id m7mr10018430qvo.128.1578592421803;
 Thu, 09 Jan 2020 09:53:41 -0800 (PST)
MIME-Version: 1.0
References: <20200106153520.307523-1-jlayton@kernel.org> <20200106153520.307523-7-jlayton@kernel.org>
 <8f5e345a-2743-5868-3d89-017db6ae3d8c@redhat.com> <9cd39feb0b8d92f29af69a787355b89359c797a8.camel@kernel.org>
In-Reply-To: <9cd39feb0b8d92f29af69a787355b89359c797a8.camel@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 9 Jan 2020 09:53:15 -0800
Message-ID: <CA+2bHPaML5kSYaZrNPsDHYTv-7_scEPWZ2xkD0fxp2Pg5G1cCA@mail.gmail.com>
Subject: Re: [PATCH 6/6] ceph: perform asynchronous unlink if we have
 sufficient caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 9, 2020 at 3:34 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-01-09 at 17:18 +0800, Yan, Zheng wrote:
> > > +bool enable_async_dirops;
> > > +module_param(enable_async_dirops, bool, 0644);
> > > +MODULE_PARM_DESC(enable_async_dirops, "Asynchronous directory operations enabled");
> > > +
> >
> > why not use mount option
> >
>
> I'm open to suggestions here.
>
> I mostly put this in originally to help facilitate performance testing.
> A module option makes it easy to change this at runtime (without having
> to remount or anything).
>
> That said, we probably _do_ want to have a way for users to enable or
> disable this feature. We'll probably want this disabled by default
> initially, but I can forsee that changing once get more confidence.
>
> Mount options are a bit of a pain to deal with over time. If the
> defaults change, we need to document that in the manpages and online
> documentation. If you put a mount option in the fstab, then you have to
> deal with breakage if you boot to an earlier kernel that doesn't support
> that option.
>
> My thinking is that we should just use a module option initially (for
> the really early adopters) and only convert that to a mount option as
> the need for it becomes clear.

Module option makes sense.

A mount option to disable async ops would also make sense. I do not
think the default behavior should be off-by-default.

(Someday perhaps the kernel will be smart enough to also digest the
ceph configs delivered through the monitors...)

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

