Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0744ABD58B
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 01:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442104AbfIXXly (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Sep 2019 19:41:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41735 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2442084AbfIXXlx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 Sep 2019 19:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569368512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZOKpNm8dnm6a82jGO/e/qbdKrI7hpoMwxPeHPJ8Xrs=;
        b=HGXLo4bRCxoq4z0mcY1iUjkrMAT/SosAkNywkNR6LQzCAnVSRJpsguWxCQp/PdF1nZBd/p
        rwDrtzdEKAmcXSzyYuhDJ9N0ARa8jnbY1QsV83nRVkk4ykEoNOzkB4PlIcdOMXuSvEnUdo
        42Ir0YjJjT40lF6HNbo/gxLMGz9eCHo=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-pJ8t-B1OMsqaPApgIMuxJA-1; Tue, 24 Sep 2019 19:41:49 -0400
Received: by mail-lj1-f200.google.com with SMTP id q23so1008345ljg.10
        for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2019 16:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1H2meoAoVEJlhba1ECtL8fM9CvJ1HVaK5dxoI+zOUM=;
        b=qrHGTpGfmcE0pAX8fPEl90ocRvni8/8QPeC96t2cNQc0m0IALsOdMHjRf5s3qxazen
         yLLU5xhnUKHKcgukBZEfn/0cpEmcagDLenartWDVlH/69e4HRF4KBBxDcthoIkxhwuF7
         8Pl/iqYaSElVEc7lLaQ7ceW00kc6MeuGSyd4GB06rTlJGiBEIcXWlANF9MR3JFxFcK1Z
         cFCeDV9CGOY6dsfX58VeAB9jqVsDAGaFs1UH52c/n03Q30c/4yMftHIqvru6Nvq+DEbf
         WA1E9eCqgvaqlv6yS+RiaBLbHn9nV/4vCNa4r0vamtPDOA5eNQaPUWC2UURLNT4YMVH/
         AJJw==
X-Gm-Message-State: APjAAAVpc7JH+xR/kf4BlYmgzvSNrYyMY3Ly/Xc+sBtmU8dgw7Kk9Qdf
        dyDFzyBkLyfTZ+YTGNYsCXuKr2CDfwkbJUdQT67+matJnyeiGuKFKA5Gq1i0V9jEtKJ30xz1eDl
        cTMmehxYgbvkDiPwHD6sdurLYwVJ264/tVid+HQ==
X-Received: by 2002:ac2:5e9e:: with SMTP id b30mr3519291lfq.5.1569368507798;
        Tue, 24 Sep 2019 16:41:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtksGsWiEr29oI0Y0uhenHq/r7AW9wePvJeU26H+Ns0PI0iWQItkfe69ar5G0uYgVZgmY+ctnRXnn6KNJYwlQ=
X-Received: by 2002:ac2:5e9e:: with SMTP id b30mr3519284lfq.5.1569368507622;
 Tue, 24 Sep 2019 16:41:47 -0700 (PDT)
MIME-Version: 1.0
References: <CANA9Uk7nUFcLc7L4-=3hGH-7Dcf4dt1+xVSrs7hDzgWdNB+vqw@mail.gmail.com>
 <CAANLjFq3HCJvd6R-17ip+-TqTYeQFk0Z2eSz+hkCr2B4jUyX7w@mail.gmail.com> <CANA9Uk53woKRHkOqRTRsthODL8+JOfXX4BEpNhriqdTb0wG4yw@mail.gmail.com>
In-Reply-To: <CANA9Uk53woKRHkOqRTRsthODL8+JOfXX4BEpNhriqdTb0wG4yw@mail.gmail.com>
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Wed, 25 Sep 2019 09:41:35 +1000
Message-ID: <CAF-wwdFvbTRDULTYQAK_3orwqcFLJZYQHcqPXd0d4kyF99orMw@mail.gmail.com>
Subject: Re: [ceph-users] ceph; pg scrub errors
To:     M Ranga Swami Reddy <swamireddy@gmail.com>
Cc:     Robert LeBlanc <robert@leblancnet.us>,
        ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
X-MC-Unique: pJ8t-B1OMsqaPApgIMuxJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 24, 2019 at 10:51 PM M Ranga Swami Reddy
<swamireddy@gmail.com> wrote:
>
> Interestingly - "rados list-inconsistent-obj ${PG} --format=3Djson"  not =
showing any objects inconsistent-obj.
> And also "rados list-missing-obj ${PG} --format=3Djson" also not showing =
any missing or unfound objects.

Complete a scrub of ${PG} just before you run these commands.

>
> Thanks
> Swami
>
> On Mon, Sep 23, 2019 at 8:18 PM Robert LeBlanc <robert@leblancnet.us> wro=
te:
>>
>> On Thu, Sep 19, 2019 at 4:34 AM M Ranga Swami Reddy
>> <swamireddy@gmail.com> wrote:
>> >
>> > Hi-Iam using ceph 12.2.11. here I am getting a few scrub errors. To fi=
x these scrub error I ran the "ceph pg repair <pg_id>".
>> > But scrub error not going and the repair is talking long time like 8-1=
2 hours.
>>
>> Depending on the size of the PGs and how active the cluster is, it
>> could take a long time as it takes another deep scrub to happen to
>> clear the error status after a repair. Since it is not going away,
>> either the problem is too complicated to automatically repair and
>> needs to be done by hand, or the problem is repaired and when it
>> deep-scrubs to check it, the problem has reappeared or another problem
>> was found and the disk needs to be replaced.
>>
>> Try running:
>> rados list-inconsistent-obj ${PG} --format=3Djson
>>
>> and see what the exact problems are.
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com



--=20
Cheers,
Brad

