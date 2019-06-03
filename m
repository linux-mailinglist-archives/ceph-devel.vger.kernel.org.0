Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C208C333A7
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 17:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfFCPfe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 11:35:34 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40589 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfFCPfd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 11:35:33 -0400
Received: by mail-io1-f66.google.com with SMTP id n5so14655531ioc.7
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 08:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h2Xuvzx+l4P9z4sjkUJ523igDktNkqo2hcyaGmQFGR8=;
        b=dPATpK31ux4Z3S3q86fHo5GJq6ZgesIQDfgDRdRl4GFCWVrihRXEZzTzVAMUGXlD3c
         GEWt+kJ6ADHqi6NNcpQA68UziBcosJv6PUhvZhrOwijhDpbdbHLFE6rl9216kqz1ev0u
         5T7tvCQPFVsSoiYzsEZxEkwsYImFMlmpqu9PRh4aSNB0f/KlUDb32W9IOfT1meRUWGKp
         lRC0LN64giKcU4ihuxD/7afsVxrrDgmNCAUSyQnjS3CbFmn52PswZCcjzArbORhOjASo
         p4o9MZIR3FeOlzbGNlPIrLUMlrLqBZ4m5bdfzOzzD+PyAgcN1DwQaWgZ6WhvlCsXA4lZ
         ljug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h2Xuvzx+l4P9z4sjkUJ523igDktNkqo2hcyaGmQFGR8=;
        b=ExLRs9K0XesPyGd1sInVwzDN38ote6ExnhBvuFYXw2DmH6tjjNsKO0rtdPDspU2GJG
         jOO0bp4K+FNBoRWEjWYI2IIw2s0KKkfU5gpKEDOrsVdR+AS7FP1jdoFBKOMW+OWlxMgh
         Vcfy+FBiDMODnVU42A4idK1SJNDFxST/7ZpGYDH3ifTBrqCl2JsYcw0IytIg+QYkLBjk
         TUCsiy/XI/KGkqWliASMuI1fR6w1p7fMJgLkM7oOLUMsSbECuKHabVoXPo3jYh4xCnSh
         gkUtYuxgmCuZUwzVhc8Lodk2iapRIJPQaU2ZF8VwXsQNHlYEmVjRt/3RC+J5jwE29R9g
         Z50g==
X-Gm-Message-State: APjAAAWMuEiE0k+3dWG/T+uGbpPV8R5hHyhNng++2iKmvvnJYHUaL/+x
        Q2obPblqRqrGb0LSqMo/v1Bx8yR5ApLpZ4zyGsg=
X-Google-Smtp-Source: APXvYqwGprQKAX2QgRabub4VywVaavUGbcintp56I7iKFKjmPcM9DXeRB/D4H/or/teTq7rr3nf334QFGB+WanTA8mk=
X-Received: by 2002:a5d:91cc:: with SMTP id k12mr257526ior.131.1559576132534;
 Mon, 03 Jun 2019 08:35:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAJACTufz=iQUcPW75vxX0qM6xK7Sd8XuDHrdZrAt4B9uGJGvog@mail.gmail.com>
In-Reply-To: <CAJACTufz=iQUcPW75vxX0qM6xK7Sd8XuDHrdZrAt4B9uGJGvog@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Jun 2019 17:35:37 +0200
Message-ID: <CAOi1vP_nucPE4h7OcfSCDEJqF7OQkj=T8qwAAPA_ZUva6+zxtA@mail.gmail.com>
Subject: Re: [PATCH 0/2] control cephfs generated io with the help of cgroup
 io controller
To:     Xuehan Xu <xxhdx1985126@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Xuehan Xu <xuxuehan@360.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 5:59 AM Xuehan Xu <xxhdx1985126@gmail.com> wrote:
>
> Hi, ilya
>
> I've changed the code to add a new io controller policy that provide
> the functionality to restrain cephfs generated io in terms of iops and
> throughput.
>
> This inflexible appoarch is a little crude indeed, like tejun said.
> But we think, this should be able to provide some basic io throttling
> for cephfs kernel client, and can protect the cephfs cluster from
> being buggy or even client applications be the cephfs cluster has the
> ability to do QoS or not. So we are submitting these patches, in case
> they can really provide some help:-)

Hi Xuehan,

AFAICT only this cover letter has made it to the mailing list.  It
looks like you cut and pasted from the terminal instead of generating
the patches with git-send-email.  Please resend with git-send-email to
avoid malformed patches and mailing list issues.

Thanks,

                Ilya
