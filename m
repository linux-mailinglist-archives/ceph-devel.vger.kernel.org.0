Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9862D1642A4
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 11:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgBSKxa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 05:53:30 -0500
Received: from mail-io1-f50.google.com ([209.85.166.50]:37059 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgBSKxa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 05:53:30 -0500
Received: by mail-io1-f50.google.com with SMTP id k24so61961ioc.4
        for <ceph-devel@vger.kernel.org>; Wed, 19 Feb 2020 02:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q838K3Lzmae2Cfvd4x1LIjBp74SKSAwVf45p6NhKwXA=;
        b=STiTzVEb0PfnXNh5OkXUNJFaRemqyeZsbz+ev+fZZnvZ8QQOamuKx0BNLdVgW4Sanq
         cX2uFSwz1nzF3ZK6SKssYwTYxhdI8XmGcLxvXQJgEGmknanh4ktXJbz/ZBOVEMg2LhMS
         LkOCMxijTDR0XeKoWIy4rcKCkO189k4WdVmrqeCRBhZEzUkRdJEFbWYtvnASfiMvvdbt
         u+T7d07ZU4ZupEKBxqJkG49QPDhFZ5JHG1YXzaTgiXVQMOb4CT0Xk5a4f4Fp0XPKTeE/
         BZVrIX1BLjZO5/Chj3Gr5w5EQe/7RO9BLP/9i16CNXyb3YdTR6AYDwRig4Gz2etAnEGN
         MCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q838K3Lzmae2Cfvd4x1LIjBp74SKSAwVf45p6NhKwXA=;
        b=Igxqif4GtVY45+jfnqkUboaNyflD6FHXVYPriOG5t48zP/HaptUr2r2vjrwpW8Vjb8
         xL10u0WQAgzxeeUwUdGSsHiZ2KqSBNJjgjzI0RUleQlE9xOz+cA2Nmmf3+cHsUh/S+Hi
         3YqoYDKqyJfnactoWYwMN0L/ZBaYlkoNowuI43ji9xISLslRslKrw7hfIv74bgyJy1p1
         MWRctCi4N+aj1UZSYCEKFmFR66XqA0vvWzCQWNGfTetVEKTSkctW4n7J7SDdEMao9Htl
         Uw1TO0qNcp9JSRUMib41oCPdA93o5mmEStZtDAbxVrJnemS8U641y+ShpxgUbQVDGj2k
         31LA==
X-Gm-Message-State: APjAAAXstLwbjDMVWlzc+ocyIVV2jVclBYq56/cYWRKd0qi+dDrveF9F
        1/oryY4XsBgduNzbH8BO6v/pumofDQ4LahV7VzKOeI5OMds=
X-Google-Smtp-Source: APXvYqxk4nCn0DfXW7KKjDc4POSsQnYC5SLuczcTBxyDCCnJrKXi3koesgqChWmU1nO6Y62F1V8XLsQ5z4bLO6wzyeg=
X-Received: by 2002:a5d:9707:: with SMTP id h7mr20289422iol.112.1582109609549;
 Wed, 19 Feb 2020 02:53:29 -0800 (PST)
MIME-Version: 1.0
References: <23e2b9a7-5ff6-1f07-ff03-08abcbf1457f@redhat.com>
In-Reply-To: <23e2b9a7-5ff6-1f07-ff03-08abcbf1457f@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Feb 2020 11:53:56 +0100
Message-ID: <CAOi1vP8b1aCph3NkAENEtAKfPDa8J03cNxwOZ+KSn1-te=6g0w@mail.gmail.com>
Subject: Re: BUG: ceph_inode_cachep and ceph_dentry_cachep caches are not
 clean when destroying
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 19, 2020 at 10:39 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> Hi Jeff, Ilya and all
>
> I hit this call traces by running some test cases when unmounting the fs
> mount points.
>
> It seems there still have some inodes or dentries are not destroyed.
>
> Will this be a problem ? Any idea ?

Hi Xiubo,

Of course it is a problem ;)

These are all in ceph_inode_info and ceph_dentry_info caches, but
I see traces of rbd mappings as well.  Could you please share your
test cases?  How are you unloading modules?

Thanks,

                Ilya
