Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69B291DE3
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 09:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfHSHde (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 03:33:34 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35693 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfHSHdd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 03:33:33 -0400
Received: by mail-io1-f67.google.com with SMTP id i22so2117422ioh.2
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 00:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0jLuftm1L4YhVEgN/xLNY8vk26uZZqTmfKRnsNEf6P8=;
        b=kvmMwzHyGHcbub7Jq9v/LS+l0H4q9I9Zbv1q5/xdNosG9YgJTqGkyxAF9BsJzEjJW6
         n6J3rjLH3Dru+IBi2lQReU+mkqhYkZ9/zLpOU4eJZ0nOAr1XWUpdaWHLhYNJ0as3nxY0
         wfHy3v77rE/wqEQJEub8c5TpALMrjDt5H/sebi3Vl74m2+uKzEP/tJSI8YuJm5dN+EBs
         QBGOTGq6YaRLhgEPcQ0RIdwKYRcgOnm8D06ttILJvslbyVPGYP868USl8xtnmK1HkU3e
         VFX1Jvvl65xOQdN8c37wfj+4x+7tGo+CkOAvvshoYC44pjWSyDgUXYcqjIQNl+h2H0F9
         8ung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0jLuftm1L4YhVEgN/xLNY8vk26uZZqTmfKRnsNEf6P8=;
        b=TN+Evdnpw1jNcW7fzpkc4T1H/RX0pLCxXDKzhCs139Jn/7sSFeDdVEcfzbyP0IOt3B
         ydlm2iLClshNDb6AQQgxKpt7GkHizeihPl16Xgu6QaAZR3LPNiJJDgU62s6Y3jYU8WMR
         x1jbFGa37tA5867XjrDI/w97XuMLv+rsH6jeAVumPpq2Pcaq2dCKWoFQAbgegOz5myLS
         9jJtplRhADdtQONX46OWJt1JEAxIPxeOIgvGw05F4ltw8SUPeWw0taMOCNkRNe9Na8f2
         Z1ifZS66izfIxAiW5yxniNKtBLGhNgLSu7Fz4IbKUtZLlcNOoHJuzOqABruUeF9NDepI
         entw==
X-Gm-Message-State: APjAAAWdCdG6spklpB6kvc4s1KPjDYeCwPuuSxuOi6Uod5rscE8VHqQ1
        OB63O+UyaJ/LM5msO2pyOrFW/rlyRlQJ3DdZY8En0ZYX
X-Google-Smtp-Source: APXvYqy2OpwwvIjuQSFmsilnWRWsPG6+yF6dfsgJq64bqylCSY6MoNq5IIwNzeTGa//FMJsDKwEv+qzBHVHdOj1ht38=
X-Received: by 2002:a6b:ed02:: with SMTP id n2mr25326202iog.131.1566200012986;
 Mon, 19 Aug 2019 00:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn> <1564393377-28949-3-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-3-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Aug 2019 09:36:32 +0200
Message-ID: <CAOi1vP8UVpSA5kMv--LQ2+34awVVWU60LQUWN7A3DfYjzpKD0A@mail.gmail.com>
Subject: Re: [PATCH v3 02/15] libceph: introduce a new parameter of workqueue
 in ceph_osdc_watch()
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> Currently, if we share osdc in rbd device and journaling, they are
> sharing the notify_wq in osdc to complete watch_cb. When we
> need to close journal held with mutex of rbd device, we need
> to flush the notify_wq. But we don't want to flush the watch_cb
> of rbd_device, maybe some of it need to lock rbd mutex.
>
> To solve this problem, this patch allow user to manage the notify
> workqueue by themselves in watching.

What do you mean by "mutex of rbd device", rbd_dev->header_rwsem?

Did you actually encounter the resulting deadlock in testing?

Thanks,

                Ilya
