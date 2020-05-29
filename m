Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A225E1E84DF
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 19:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgE2Rcm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 13:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbgE2Rck (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 13:32:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF3CC03E969
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 10:25:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m81so201350ioa.1
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 10:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fN/kt3RVtsnGY3q7reyb2J6/bV5FgRjWnakT21QqSFI=;
        b=qgXE7WVcILPYSGTPMIFLIx8/GJMjmHMykIaUY3G46l1Mb7+LxH8BbdvDWgdBmNlaG7
         Q7QsKP9tbz/rKKG7yDfsrEmFxeOO/csguOAnA/yHtkcqI8XqeBaTj4ll1nvUq9adGOiE
         0J/LC0vAm8dscXMJ6dZ+F5o+HHpiYkodvL4jx1YJUD1qGIw35FTst693dBoft2NITUuE
         qF7EZ7R3SzssRz0yo/73k/GemQ4QZx+6oZZP9YXPJLq/rtUpKO1ANBHb/Wu+dmZy64yj
         RgnGIUswwV+d6ay4luywBjOcHkPfg2m7u+ui/9RZ9+lZsXNP8L9SSA8EeXgWjWz9PYi0
         ePmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fN/kt3RVtsnGY3q7reyb2J6/bV5FgRjWnakT21QqSFI=;
        b=iLgawUxop/+E/CQAC3q2QZkBF25ezxs8GQeOsQmJtciAWowXrGEEZiZ1fwG9WVEZdK
         eGvhoYNhbAq+qSz5CvtQOejpFzTSJfz3aMgTLzb7NoEwJ/4i4rGkdMhwuq615YHbSXh3
         Og0Uv/OltgHYbw+57GC3IboBNwtEeiCOpWUq8wXhvbJVdRrX980/uobRqvlgTEEBkJhs
         RNN81DciwS+dSpuNUC5h/DjZHZf7eFsIT2R+a5L8KrGISAZyccMYh4cQaSJ80gl383wW
         s6gVWTc6PSQsOv62Yx4BVdN1ITYAcRbrzDpMNjEDz4fUFqZQYDXj7aBlo84usD941hG0
         CrBg==
X-Gm-Message-State: AOAM530GejFEe6jOu67lGV5cQ4TSv84NXqXlmV7hVDgqKh3OYcGFWEzI
        iVO//Qtx5sBaW4OI0HwywcSmpvxtaJWQoH9tj4M=
X-Google-Smtp-Source: ABdhPJy3SSZZC+56Vw4hE2oKIX1QHfU6SjgCCc7Zb2Kxs4s1ksyTpNdjQxzqCxgFZFf0EIfPPJfQu6RaSWjwTz7ITRY=
X-Received: by 2002:a02:3b4b:: with SMTP id i11mr8357178jaf.16.1590773151500;
 Fri, 29 May 2020 10:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200529151952.15184-1-idryomov@gmail.com> <CA+aFP1D_povJnBfH5pT8E7OVK_WHWa0TtBwRCxB=OmscTjGf8Q@mail.gmail.com>
 <CAOi1vP83RsnP7JB2VGfCZv+hwLTDuuzC1vwJpvbX84NKSTZ6jQ@mail.gmail.com>
In-Reply-To: <CAOi1vP83RsnP7JB2VGfCZv+hwLTDuuzC1vwJpvbX84NKSTZ6jQ@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 29 May 2020 19:25:57 +0200
Message-ID: <CAOi1vP_wTJ_WeqNU=X2tXCW=PopnFrdHTHv-i=eMeubSyu4jGg@mail.gmail.com>
Subject: Re: [PATCH 0/5] libceph: support for replica reads
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 29, 2020 at 7:21 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Fri, May 29, 2020 at 6:57 PM Jason Dillaman <jdillama@redhat.com> wrote:
> >
> > lgtm -- couple questions:
> >
> > 1) the client adding the options will be responsible for determining if it's safe to enable read-from-replica/balanced reads (i.e. OSDs >= octopus)?
>
> Yes, we can't easily check require_osd_release or similar in the
> kernel.  This is opt-in, and I'll add a warning together with the
> description of the new options to the man page.
>
> > 2) is there a way to determine if the kernel supports the new options (or will older kernels just ignore the options w/o complaining)? i.e. can ceph-csi safely add the argument regardless?
>
> No, older kernels will error out.  I think ceph-csi would handle
> this the same way ceph quotas are handled (i.e. with the list of
> known "good" kernel versions) or alternatively just attempt to map
> with and then without crush_location and read_balance=localize
                                               ^^^
Typo, read_policy=localize.

Thanks,

                Ilya
