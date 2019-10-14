Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7EDCD64FC
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2019 16:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbfJNOVH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 10:21:07 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:45155 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732262AbfJNOVH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Oct 2019 10:21:07 -0400
Received: by mail-qk1-f178.google.com with SMTP id z67so15992360qkb.12
        for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2019 07:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SB7Qc3NV18OBw6z1CwFbLBhjYxNJZFHhpN4FWljXwPw=;
        b=cl4gRU8gS78S7u4Cm02PzU9YHAdR/lMHuCZ0MY0XClv5v82hgQ5sGbZm81V4v9CpuQ
         YRNM9MjSgQfE093qxk6n7oq4sbyArQotPvmoqLHemhF3wVDuppD06XTu0vSia0RtXxC1
         jQUuyl3RJGocqJJuLvHRuNCEWvbaNnM18kCNLm3UsSR4h3FBcgFAINRIC7qqO1AMWMWP
         OxBVP0r9qn586mRtBtTwoeT2usD9654SK9tiNh2nh9XF4DTXb8A6vyfnRVhkiDGrNqED
         kXwttoYh7UBYWvZkTs3XNjAnQs9nI/8Fo57K9p3IcSJ86pC22ghBur4caIFPDScCD/+x
         xVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SB7Qc3NV18OBw6z1CwFbLBhjYxNJZFHhpN4FWljXwPw=;
        b=Dej+a3/XK7/Hl5LlP5cHOZj6SBilLOqQmdgW4koJp/tNwv+JxaUzajm3hjuKf/xpzJ
         7JyhoY+m8Y9+Xvv2fIQGQdWhEcjsccEWymd4SdG8j9MkPcuUOmeBBtQ8A99d+OififE8
         HoTSoikhs43dGjgrKEEPeS6+64ML4t9YlPSLzwNynKeuCQZrU7q811+6kX4nTnP1+cRB
         yV2CiU/7sFw0dHhHtNvYdRzCbjw+b0JEvLNj+iPn8A5HvmFKbol+N8ifhp1D5aZjX06H
         P5bT6BFckgkZWtLzrfUIzWsEHiCPluKK9bAxsTD21Q5OkyQwTlKpp9z4Qceh6W5fR7J/
         JErA==
X-Gm-Message-State: APjAAAVSWur3zAxoVD9V5XpuAxyq7mt8PHw8Vx9cwtgh3b3pNFlrs9Wt
        4pdBKwnSW6WwNXEQHFYo5IIvcHuYUZuC8wYoq55kIDIGCQg=
X-Google-Smtp-Source: APXvYqxcYFUzKD3hjPDxTl+Pd2dvWAXqV6YP2qdkXMXXIFp7ZSTUBtUrITP0TB7V9U10M2ghXI3pQPb4rfjtCQN/tU8=
X-Received: by 2002:a37:5604:: with SMTP id k4mr30260534qkb.455.1571062866222;
 Mon, 14 Oct 2019 07:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
 <e9890c9feabe863dacf702327fd219f3a76fac57.camel@kernel.org>
 <CAANLjFpvyTiSanWVOdHvaLjP_oqyPikKeDJ9oMqUq=1SS7GX-w@mail.gmail.com>
 <78d8aae33c9d4ccccf32698285c91664965afbcd.camel@kernel.org>
 <CAANLjFot-VP0dUz7Czw6C=NvP8cXOK--Kt8Gd8HecMLHp1CPYA@mail.gmail.com> <95f300bcb6886fbe16cfd306d0021e451279d793.camel@kernel.org>
In-Reply-To: <95f300bcb6886fbe16cfd306d0021e451279d793.camel@kernel.org>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Mon, 14 Oct 2019 07:20:55 -0700
Message-ID: <CAANLjFp8g_mtmA=XdXdCpBEyNo38eSk=ifjoPWJyFeFth6efTA@mail.gmail.com>
Subject: Re: Hung CephFS client
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 14, 2019 at 2:49 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> It's in running state, so it's not sleeping at the time you gathered
> this. What you may want to do is strace the task and see what it's
> doing. Is it doing syscalls and rapidly returning from them or just
> spinning in userland? If it's doing syscalls, is it getting unexpected
> errors that are causing it to loop? etc...
> > I looked in /sys/kernel/debug/ceph/, but wasn't sure how to up the
> > debugging that would be beneficial.

My associate got that stack from running `trace-cmd`. I'm not sure of
the details.

I tried to strace the running container, but it won't let me attach,
seems that you need to pass in a cap when starting the container or
sideloading with connecting another container to the same namespace.
This is a bit out of my area of expertise. I'll see if my associate
can get a trace from it.

> See here:
>
> https://docs.ceph.com/docs/master/cephfs/troubleshooting/#dynamic-debugging
>
> ...but I wouldn't turn that up yet, until you have a clearer idea of
> what the task is doing.

Thanks for the pointer, not at all what I was expecting.

> > We don't have a crash kernel loaded, so that won't be an option in this case.
> >
>
> Ok. It's a good thing to have if you ever need to track down kernel
> crashes or hangs. You may want to consider enabling it in the future.

We have a lot of things we are trying to get in place, this is one of them.
