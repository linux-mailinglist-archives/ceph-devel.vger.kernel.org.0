Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC30125F9D
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 11:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLSKpz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Dec 2019 05:45:55 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45466 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfLSKpy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Dec 2019 05:45:54 -0500
Received: by mail-il1-f193.google.com with SMTP id p8so4445608iln.12
        for <ceph-devel@vger.kernel.org>; Thu, 19 Dec 2019 02:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vkiSuZycSI5zUnh5IyX2UW8ljaGAsOW3wFB46kEoxqQ=;
        b=r5itbMnWobTEJdTCEgSW4wXxnLMdZg3GPVXe3gnRJOqtealmtXx/ZIPfwXYIZgRvws
         Unqvpv0vzQwLzoq2tvesvvv2v0YjkjrcPSkmUfe1kbOE324KvpcJlR56ln7LFehTOcQq
         TP7OFUtUr0Jf9Jg+sT+X+zLQsqcn7gBcEZ4oljvzdnQ6iRTx8HwFuIBNzcT6JS6Y6lbz
         OWtTd9r/GGVbVqBjU4eSzhw3gP4+HhfoXD7rH4KEr4/inB4rtC87Dv6iKScF/Ee7JJHt
         ardwQnRhnPDYzI+HSCBpaXuXmWLtqfi7d+mC+NLijDzNAt573IxqZjoXsxx10XaxsHJw
         F9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vkiSuZycSI5zUnh5IyX2UW8ljaGAsOW3wFB46kEoxqQ=;
        b=kxNZKiC6TBsC0gqruCYqUO/9U1fD5/alggFBOU56hdV/k5jFNUakupfsD0eF+QmP9K
         q+gWEteSJp6R9NXOzd0XPDbX6+VqlJvp9CHE8a36WE1+mgjIJ4mBqBEap449HZ/fiu9n
         bl+1nfOjAqPovyNaixu1VFKfj8YrQfqJkeDBSRI2hETdBbWLScCJJ+y4YXXOBnFg9OqE
         NTjox3B19w544+CApBaer1tMAcdV+vnzWLMOmHTzOrwFUJ6nVRccF4PSOaAnHEZF4JRp
         T/0iyB6ksvy7KxZolI5NfCJBG939LCHJh75xQzZt1fsDUqhQWqswgbllAtfFVxEFWNYl
         bHfw==
X-Gm-Message-State: APjAAAWRVq7XftsI0BT8wxolWsCld/T8/zg9ZR3aEmYpkzGlcgPZ1+Pi
        OrHPcgtj6sguHzEE2VMLa8Je1gRIHhaCw8G7xtL9NDCRLmc=
X-Google-Smtp-Source: APXvYqyCIvj0N/lqTijUSIzV6YNq0n0Jc9khI0un7csfkS6+ZYUKEPX9m/epipR9GPPLZ1OUWrF66MVxrlyYBb1YUPY=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr6259462ilq.282.1576752354128;
 Thu, 19 Dec 2019 02:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20191219010716.60987-1-xiubli@redhat.com>
In-Reply-To: <20191219010716.60987-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 19 Dec 2019 11:45:48 +0100
Message-ID: <CAOi1vP8XJ4nm1esUaQEcu3pQgmb_MUuWRqg6Eeip5-TXVwKmPg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: rename get_session and switch to use ceph_get_mds_session
To:     xiubli@redhat.com
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 19, 2019 at 2:07 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Just in case the session's refcount reach 0 and is releasing, and
> if we get the session without checking it, we may encounter kernel
> crash.
>
> Rename get_session to ceph_get_mds_session and make it global.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Changed in V2:
> - there has some conflict and rebase to upstream code.

Hi Xiubo,

There were two patches in the testing branch that weren't meant to be
there, one of them touching con_get().  I've just rebased and removed
them.  (5.5-rc2 is broken, so it is based on 5.5-rc2 plus the fix for
the breakage for now.)

It looks like neither v1 or v2 were based on testing though, so this is
more of an FYI.  The reason I'm still sending this message is that both
v1 and v2 appear to be whitespace corrupt and will need to be redone.

Thanks,

                Ilya
