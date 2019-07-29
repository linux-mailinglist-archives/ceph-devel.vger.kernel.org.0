Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1804787AB
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 10:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfG2Imh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 04:42:37 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38750 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfG2Img (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 04:42:36 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so43038140ioa.5
        for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2019 01:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5TNsxgSGr0hqSgPDD85uDWoUArEOMGS+PXx5/qD+LA0=;
        b=ni4Z6xXhk7LNagNGzy5DiDUzVswBvdwa5QzPIdwrWcd27lKIoKZhEsG2D8K3D+sMaK
         zby+HqskLg/j36dyffAJ3GqeQHfB+pnTodVBALBylEELRzSMKI1az4jmF/YICngNmcuE
         Q4eO8OatePUdzpyJniWsBgWIkVhOpL2xilUkpKSTi6eUvbKtTIc6LU7CjPjeePOe752n
         plV2ac1lNL8SRXLAviTogrWdDVZp7hXow86fGZhPaI3CoXtigvGVNnZu47MiagHIMdpW
         TKpA9+XCC58ue+G8vjRHzRmV8AggqdEMtcI6ZaLdoz6h5+bjNIjsutOGOMDRR5U0e1fO
         8lJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5TNsxgSGr0hqSgPDD85uDWoUArEOMGS+PXx5/qD+LA0=;
        b=Om3mrh46kBg8suD31M3JnpQoCDu5uFycbQ4MZU7s4ihZ4z06kRb+z5Uo9YyQbq9LX4
         K6x80C1jxEEhFFlVmIL6gXvnZwGr5Xrqm2bhTt9wG7pmktAdR82AhfcRABytsFvx4YIe
         ruflnp21rCy4OcyXMITT7dbr/2U6P7XQ4DlZQoe9c8SlnZHg6M7rYJSHCsg6HafOBxm2
         qtDYMIYh63NNwJSvZKolckM57EW7nU/NWYpOz3C//40W5YX6ZzWTpxLY8GGleLVEx88Z
         NOfS0Qh/8BI9gfLMmYc5FlWcX8S1TtHIk91rjwTuNjRzGLbSlFMVRLBnNgKjfis5V+/l
         K7/Q==
X-Gm-Message-State: APjAAAU8kEMkOGnjyimEMukkwVOxHK13KLrpWErTe1iV13Pv8IQIqzOJ
        mZfpOR23u+y9JxpyCna+0ovxr/bLfPl00GxQKUk=
X-Google-Smtp-Source: APXvYqxH2Xuqp8iVe9BIdnqn/WqQjNuHgHoYXYFdZHPDlAlcfvXiyIdGUSnMLcXjpgAFdKEIzp29XUT1B46lKbyShLU=
X-Received: by 2002:a6b:7311:: with SMTP id e17mr54849946ioh.112.1564389755552;
 Mon, 29 Jul 2019 01:42:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
 <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com> <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com>
In-Reply-To: <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 29 Jul 2019 10:45:29 +0200
Message-ID: <CAOi1vP-6Xd_jrnRf-Q7qL0SKUQ3kXHuKfOUmx_uYqQEX6R=PJQ@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 26, 2019 at 11:23 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> Some additional information are provided as below:
>
> I tried to restart the active MDS, and after the standby MDS took
> over, there is no client session recorded in the output of `ceph
> daemon mds.xxx session ls`.  When I restarted the OSD.13 daemon, the
> stuck write op finished immediately.  Thanks.

So it happened again with the same OSD?  Did you see this with other
OSDs?

Try enabling some logging on osd.13 since this seems to be a recurring
issue.  At least "debug ms = 1" so we can see whether it ever sends the
reply to the original op (i.e. prior to restart).

Also, take note of the epoch in osdc output:

36      osd13   ... e327 ...

Does "ceph osd dump" show the same epoch when things are stuck?

Thanks,

                Ilya
