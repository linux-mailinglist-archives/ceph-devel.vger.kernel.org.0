Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF4230FFF
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 16:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaOSo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 May 2019 10:18:44 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37229 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfEaOSo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 31 May 2019 10:18:44 -0400
Received: by mail-it1-f194.google.com with SMTP id s16so15495263ita.2
        for <ceph-devel@vger.kernel.org>; Fri, 31 May 2019 07:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hFdA4CxoVophfWwjSoIGVHhFuYUAey+fA5JmGYZKi90=;
        b=QM9qrZ5yxZ1xmmJP27+9kY3YYKk/ypY/DsZdY6tJGc1OA7ABwcqrhgQun2bzkE0pYt
         zmyz7ze27CWqQbbS+8yJjkNNasWhrWCXpGa7GF+yTHtA5j52lQr9Vfi36LMsJoBZd0Ev
         h+zjnUGQ1Vl/+f8LcMGJLGGQ7fR8Y26SkboI/vnQEOe05BKdJK6Qh9NEkw0Zc3Vqok0i
         jQC2HNdVyMenM6DdSGkmBPTqU7mjWZBc8KSOieaiD4nRLzTovaf4nzGIbPCw1GuR6TOw
         ttGQwx7yt3S1/WBrHPHq4138ik/q9TjN5ZFlIKesLZ3fc2ddFmxbutO8Gj94BcwIRlDW
         Rjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hFdA4CxoVophfWwjSoIGVHhFuYUAey+fA5JmGYZKi90=;
        b=kIuxjE8zqv1E/OCgf6OkV5/P29diTDjjBE3CAV1euamDw+vdXlsrUFNJU11iu4zLk1
         Es2T4MJf6ApR7kci0z74vKH+kl06VzvR9HrZwk9JtWdvjyEGSgJUBpSiSJewk75UUSDZ
         YX9rzykwqs2lU5NxUrSwtl4MRfXpblmbfriVmReszWv9NIUZnJJXQfWLLUkbf8DM7+4q
         VkJhoLTelXd33EAqbX6z+h077M+LYa2ai8Pt7j6v8ulZDlJd6br3pJ9qwNopmrzlsnoT
         3HpCwgMNjBCI9OqQfnx0ExDVfSKK8h0jZdUucYHu7aYPghiOotxCOw3QDGi0A3QX0K1j
         C8HQ==
X-Gm-Message-State: APjAAAXg3vzT+hAM7iQbgrnbzj/N3zh9FAY4ffvOkHXrXWux3n/RoLe/
        hstFnBsmJSFoYpoDIBd5g9pkOqArPY9HUhE52Pc18DUW
X-Google-Smtp-Source: APXvYqxj/SOkxWektWtATUfeU5C9RS8HJBO+OaAWEVVeHmFn4Ui7djtpNp7oQtD1tC8JiO0rR1O3oVwnZJUayl1ykBw=
X-Received: by 2002:a24:3a83:: with SMTP id m125mr7142754itm.171.1559312323311;
 Fri, 31 May 2019 07:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
In-Reply-To: <20190531122802.12814-2-zyan@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 31 May 2019 16:18:44 +0200
Message-ID: <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 31, 2019 at 2:30 PM Yan, Zheng <zyan@redhat.com> wrote:
>
> echo force_reconnect > /sys/kernel/debug/ceph/xxx/control
>
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>

Hi Zheng,

There should be an explanation in the commit message of what this is
and why it is needed.

I'm assuming the use case is recovering a blacklisted mount, but what
is the intended semantics?  What happens to in-flight OSD requests,
MDS requests, open files, etc?  These are things that should really be
written down.

Looking at the previous patch, it appears that in-flight OSD requests
are simply retried, as they would be on a regular connection fault.  Is
that safe?

Thanks,

                Ilya
