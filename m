Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585D4D7102
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Oct 2019 10:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfJOIa0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Oct 2019 04:30:26 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38339 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfJOIaZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Oct 2019 04:30:25 -0400
Received: by mail-io1-f67.google.com with SMTP id u8so43966431iom.5
        for <ceph-devel@vger.kernel.org>; Tue, 15 Oct 2019 01:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FGo/vtPdaEchslAaAi8sEYPPKMESYnHAuZfIMkyruY=;
        b=iE5XMcN8exq3F5SR6HOdYcoxCZK3EBBr5AtmHWXZghXaomYQYxiu+4eUCzFGBjcqJV
         hHnnPjmJ1lY5cwBudgQ+jdyfpESg8zMuz+9BIi1RvSwoxQ/JKAONWzCYpoYFf/aSflBj
         CnScKk0B4Y6Y/3bY4RbU2L3ok7O1+Cw3bTDUH9yHjjk5tFKdhEE1Gl0CGJqDh9Qym3h3
         NPSaRNRHhtQ2lBkR3opp0hXtKykkaMSg+HoSdurs+SryA2B0dpaVgZI2XiMi2njfsGBE
         P62sSdVmelav/QlBubtq86N03bkv9eZ/Urpvp+WaqanhAAcN6Yq/gdSR9LmMUU0I2+bE
         Q6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FGo/vtPdaEchslAaAi8sEYPPKMESYnHAuZfIMkyruY=;
        b=kisCJWV01+TXADG9qGvkxfbbqw+MZ3M7mCmAoKjOH61SHZXqFqIPwZuwpHJuvupyJf
         5PSgl7fw+JJn6x+igSml+POdkGAfU9tGjAV+/3+bTGOg3Q0vKQHTdn/hz3GY2ZfrAZOr
         +BXAOzQDUrDbRFgyS8tgF8Ua4UrfvpTKRhzCmM862k796NbWvR0g4APYNKmun09unTJP
         RAC/FmG2CaibvR0QvSI12eT313AtVB2he/bDEYCLXp7HokMRoEF3ia2GxEbyfxRoeOvo
         NFi086s8IFbuFn0xoV2DDiur+RHXndsYdZYAqO+Oh/NMsgKI90PMA1tIwzG69Sic75Yg
         dgXQ==
X-Gm-Message-State: APjAAAV0FodRAD8RE0Q9wuykzVkthXWSf2Ztu1+fgrXFKczemqRtrN12
        AZDoPwaDZ94doy1BOAz/03sZG18csZp11s83UCg=
X-Google-Smtp-Source: APXvYqyrcZtB5y5ExQdpTexhlmt/DIvWKm2j7ijGDkuFwQ1AZpISg9B250CaYXI1hNnilq33hukDi9QRwYUtEU+mo58=
X-Received: by 2002:a92:d24d:: with SMTP id v13mr5096759ilg.112.1571128224826;
 Tue, 15 Oct 2019 01:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191015025242.5729-1-xiubli@redhat.com>
In-Reply-To: <20191015025242.5729-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 15 Oct 2019 10:30:31 +0200
Message-ID: <CAOi1vP-nPhir17mobS3wf8cw4ySeSOoctgnfdcbgKB5OgYtfKg@mail.gmail.com>
Subject: Re: [PATCH RFC] libceph: remove the useless monc check
To:     xiubli@redhat.com
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 4:52 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is no reason that the con->private will be NULL for mon client,
> once it is here in dispatch() routine the con->monc->private should
> already correctly set done. And also just before the dispatch() in
> try_read() it will also reference the con->monc->private to allocate
> memory for in_msg.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/mon_client.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 7256c402ebaa..9d9e4e4ea600 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1233,9 +1233,6 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>         struct ceph_mon_client *monc = con->private;
>         int type = le16_to_cpu(msg->hdr.type);
>
> -       if (!monc)
> -               return;
> -
>         switch (type) {
>         case CEPH_MSG_AUTH_REPLY:
>                 handle_auth_reply(monc, msg);

Hi Xiubo,

I applied the same patch yesterday:

https://github.com/ceph/ceph-client/commit/dd6b2054abec7e9a50c330619b870a018a5fd718

Thanks,

                Ilya
