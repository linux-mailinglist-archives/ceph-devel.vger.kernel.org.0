Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DFA1277C3
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2019 10:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLTJMC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Dec 2019 04:12:02 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44883 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTJMB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Dec 2019 04:12:01 -0500
Received: by mail-io1-f67.google.com with SMTP id b10so8663965iof.11
        for <ceph-devel@vger.kernel.org>; Fri, 20 Dec 2019 01:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5kK7Ajj8r/NUJqGLlymHq/N0JWj3m+BBUzFC7A7xUQ=;
        b=vCON1pJiOesp7no+nOMZZXt0iiJgq0zHSX99t+vqyerlqfXKSu/ZN+KmE4mms59nYo
         GJWYoV2Cy3k4ayTlhEV8ywqsFbVo9LnjRvrCazDqsjXgnmy0E6QyOsFIkNzVZNttfSGl
         2aF3M5ZSLMM8mG45W5zokGvzx2S3dum/vMzCDYLr8hI7Q6FrjTjPln6H66hSJsZJdxzX
         EwYbv6JYR7EXsKnSdbRrMc701qWIIVnpQUSHeJcx8Mh6+dHECwzLgFbInXdkto/dCzvd
         o21BFXZCSvnHxoskVVh/QLyxhOoo1Z2QwyPxxAMpKojePEAxIis7tL6l8wyQoH39Xl9A
         hvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5kK7Ajj8r/NUJqGLlymHq/N0JWj3m+BBUzFC7A7xUQ=;
        b=ijLS/yWhVAMHWH5S7lH5gFbJn1Yqy+rmfvmHvHhSUWUymlfyRami8B++FuXK2rkr2e
         P5DpJoccyHhZ6XN/qgnsU8HR0riaa64GBIlYHNACFlZ1MWdRhNJ2zwgduR54cXGxaQrv
         TSuV6upBuHNSjNq19B05mnP9DMwU5gZfDO52LJV8AwCpk0QJsZK0Vue/MdSzQgEN/cAD
         LmlpUqr6Q01eRnmdNUbfZ3ED8yFLhL3lWTTWa4m220UQH0fL3rw2zgzDCIz/66CJNOfP
         44MfJPq8pxtZopyr1+iw6b1+k4+YwhT34oq4v9BX4IRfuA1UJDhtiUJYQQx5TQ5av4uQ
         E1LA==
X-Gm-Message-State: APjAAAVL1AkaYC9DoyMLGziYaZVJ2urj4eLqS4JEFEo8vEak7Wk5NqIP
        NtJzWhqpTmh3Pkcjlq43x1zXLDszTv1z63jFWW0=
X-Google-Smtp-Source: APXvYqyXvTSESfFoLZioacv5r2I0Esc9bTAFSGyIzr+FHDhxYBzs/DgmE26gbHGeab7lL+xN0Ahb0dqHlGMlL0TsykM=
X-Received: by 2002:a02:cc4e:: with SMTP id i14mr11163813jaq.144.1576833121208;
 Fri, 20 Dec 2019 01:12:01 -0800 (PST)
MIME-Version: 1.0
References: <20191220004409.12793-1-xiubli@redhat.com>
In-Reply-To: <20191220004409.12793-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 20 Dec 2019 10:11:56 +0100
Message-ID: <CAOi1vP85em7ase08xywaOTfaxrsMq7Y9yeYcxcgKz8QH=oxOGQ@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: rename get_session and switch to use ceph_get_mds_session
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

On Fri, Dec 20, 2019 at 1:44 AM <xiubli@redhat.com> wrote:
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
> Changed in V3:
> - Clean all the local commit and pull it and rebased again, it is based
>   the following commit:
>
>   commit 3a1deab1d5c1bb693c268cc9b717c69554c3ca5e
>   Author: Xiubo Li <xiubli@redhat.com>
>   Date:   Wed Dec 4 06:57:39 2019 -0500
>
>       ceph: add possible_max_rank and make the code more readable

Hi Xiubo,

The base is correct, but the patch still appears to have been
corrupted, either by your email client or somewhere in transit.

Thanks,

                Ilya
