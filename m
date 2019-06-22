Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1604F919
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Jun 2019 01:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFVXyf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 22 Jun 2019 19:54:35 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:36347 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVXyf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 22 Jun 2019 19:54:35 -0400
Received: by mail-ed1-f49.google.com with SMTP id k21so15725861edq.3
        for <ceph-devel@vger.kernel.org>; Sat, 22 Jun 2019 16:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9xLfBjkZdBq9qJDiQ1Ilcz6wdzjU8K99FUkoWtUMRLM=;
        b=UV4jx9M7vD43Hh3a09rKAr/vseT/jg7yy84WD+eFcQ5fFHZhzb89ActorjMMnBkwvn
         5vnSq8tSghIcuKfm+3uEv9JP0DAu4TxMxX99/3DiFNaw0nWuHJkNSAaSEIntbMWec6Me
         OjWPma+qw+PjgeK4r9hZy2XS8H3vDu5qAj/gFaf23JhTkG9J8KzzvzYxjG75N6oQKPSU
         b1lkNQmhidKX6pPVF7n/zlz9+YM3CiFeQ3i34DVk3f1maxkDadPHrEtsbs3yel/cFdT8
         mesVEEIgfx3YSLyf3ew0Pu9tzLc8hPnDAcNdFdE6c3IzgLk83m0LnScKDeg/SxLQSVHN
         0/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9xLfBjkZdBq9qJDiQ1Ilcz6wdzjU8K99FUkoWtUMRLM=;
        b=o227Nn55Bt+dpY2i9eD+gvjjUUJKtlEt++6YE2HTIlctXVcwY5HA4f+tXnOhIotsNn
         bWg5vrpJioM1X5SDGCB+abg2Se3vL9A5iQp4cfP+rNp2u17yupMPEOc6MK38cseJXJBR
         EpahBxzRFI473gEk43a9yHMybKRo8ORYS8k3ardfhrhBrUstHDTjs1vkJ5dZn7MOPlpZ
         migY4Ec9epg5qP2Qh+h8xljveXJzxm7IXelNB4mr33IS3NwEcKZ9rPXgfmQyRnPzRk3g
         ew9kz/j5QoDTppmIy4t89pkY7Ofb9Coa7M0On24poqO9IgmTZcjERyOsfhZ1DUBJNNuy
         tEIQ==
X-Gm-Message-State: APjAAAVdyQtX8emRXeJ8CxE722fNljecRRKwTSQs+Yct+Hs98p8ad6gQ
        ylLMvzZDiPJANfRxiEEF2q32QDNGpT1k8MgyDh8LxY6xEzY=
X-Google-Smtp-Source: APXvYqxeyzCFVeBowSJfpA/5gO3vCgFKnBjRn65eai50izf1ONvzf+dx3xb8shcJQ5vdCcwwW7VV3Z9JTZRraPBR7jU=
X-Received: by 2002:a17:906:5a05:: with SMTP id p5mr73994093ejq.193.1561247673556;
 Sat, 22 Jun 2019 16:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAKO+7k304JfiN3Drgy9BDsKxXzCip7180NckQoeBo2BJxb2xgQ@mail.gmail.com>
In-Reply-To: <CAKO+7k304JfiN3Drgy9BDsKxXzCip7180NckQoeBo2BJxb2xgQ@mail.gmail.com>
From:   lin zhou <hnuzhoulin2@gmail.com>
Date:   Sun, 23 Jun 2019 07:54:21 +0800
Message-ID: <CAKO+7k3Yjmo2WSo=y-tv4SDQ-WV6c_nciquLUsttHZayoKpk7Q@mail.gmail.com>
Subject: Re: near 300 pg per osd make cluster very very unstable?
To:     ceph-devel@vger.kernel.org
Cc:     ceph-users <ceph-users@lists.ceph.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add more details about the newest chain reaction fault.
1.one osd nodes occur osd_op_tp and osd_tp timed out (the reason is unknown=
)
2.then many osd no reply occur, from other nodes and the first fault node.
3.then large number osd wrongly mark down, starting flapping, large peer
4.then the first fault node hang and can not ssh login ,when I set osd
nodown and try to set the the osds in the fault node to down to
recover
5.then peer pg changed
6.then more nodes hang, begin disappear monitor data, can not ssh
7.all my vms hang

all this is just after I ceph osd in.

lin zhou <hnuzhoulin2@gmail.com> =E4=BA=8E2019=E5=B9=B46=E6=9C=8823=E6=97=
=A5=E5=91=A8=E6=97=A5 =E4=B8=8A=E5=8D=887:33=E5=86=99=E9=81=93=EF=BC=9A
>
> recently our ceph cluster very unstable, even replace a failed disk
> may trigger a chain reaction,  cause large quantities of osd been
> wrongly marked down.
> I am not sure if it is because we have near 300 pgs in each sas osds
> and small bigger than 300  pgs for ssd osd.
>
> from logs, it all starts from osd_op_tp timed out, then osd no reply,
> then large wrongly mark down.
>
> 1. 45 machines, each machine has 16 sas and 8 ssd, all file journal in
> the osd data dir.
> 2. use rbd in this cluster
> 3. 300+ compute node to hold vm
> 4. osd node current has a hundred thousand threads and fifty thousand
> established network connection.
> 5. dell R730xd, and dell say no hardware error log
>
> so someone else faces the same unstable problem or using 300+ pgs?
