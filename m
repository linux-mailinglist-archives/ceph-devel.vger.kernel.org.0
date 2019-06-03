Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E7C3398C
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 22:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFCULd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 16:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfFCULc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 16:11:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7FAB57E449;
        Mon,  3 Jun 2019 20:11:32 +0000 (UTC)
Received: from [10.10.122.47] (ovpn-122-47.rdu2.redhat.com [10.10.122.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 290175D71A;
        Mon,  3 Jun 2019 20:11:19 +0000 (UTC)
Subject: Re: 13.2.6 QE Mimic validation status
To:     Nathan Cutler <ncutler@suse.cz>,
        Yuri Weinstein <yweinste@redhat.com>,
        Josh Durgin <jdurgin@redhat.com>
Cc:     Alfredo Deza <adeza@redhat.com>, Sage Weil <sweil@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Neha Ojha <nojha@redhat.com>
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
 <CAC-Np1wR4ik58P=UPLuuBxhqbG_REx1UFp4mDPNdBiNQFW9W_g@mail.gmail.com>
 <CAMMFjmGro96-bhMOe2KGYjZLAu-6RrNKAvOom+wP3ovg_+ss7Q@mail.gmail.com>
 <fc64e04b-bae8-8e3c-a561-ab3d0d1489a3@redhat.com>
 <CAMMFjmFOGru6K3O00D9a+==VwZV4qBZKHHyjHsdCRm+CDi9jQg@mail.gmail.com>
 <5190f63e-ce2a-f023-685c-f2d6f49fb211@suse.cz>
From:   David Galloway <dgallowa@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=dgallowa@redhat.com; prefer-encrypt=mutual; keydata=
 mQENBE60O2sBCADafZy0luRceto63vARvurZ7oepCBc+yBiDHHcFLmdZLs0nugjyYa1V1WW/
 j/tMPkjmQPGT1IcoXIrhppUXKrwXMkK4JB56GHI3cdximVuRMmHCY45ZbmAL7YnuNXz+5jbs
 iuzarsc9W3SyovQUx9n1lUymk1lASaPfNVdgzxl0/FHpKMhEqJGo0eQPh8o5M+ybZS9zXKNa
 QPiXJKLiHuise1hP4529ZTExjCqk+R3x6y7YwySKSFUhEVwY7ksU0rr/Xv5VVEsrLgS4nENe
 u9UQvJq2hp+RhgBH0ZV9+jLgwoYxjqbifJDlghbDPe7rhAfiD/xvoQFgAy/AOkVPRKHVABEB
 AAG0JERhdmlkIEdhbGxvd2F5IDxkZ2FsbG93YUByZWRoYXQuY29tPokBNwQTAQgAIQUCVfr6
 SAIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRA4J2vQ1bgO+m5hB/kBOH7I2uhhhvGH
 BzGFKSh/1C9NO8ECg5N//b7xu9EtQfoVgNODTYqpG0mhH9phV7Cvld5gAlX3YV/m4lgDwJH9
 5fcNB2x7M6OEY2kOI20DxBKxVDmamhmQLQzm2ZFqbfHwh/H6zq3jdXWCbp8LQ9uvta5qbsFp
 rU4sVg2AhKAPrvr2JoO7MLVCdNfRhwdJFwvxlc6ltilateChU5dHpy2/2aSM3794VLZXQZkD
 Ei5PIc9XrXOKqqpbwMuizlh/tNA0O1a3jY8ccl9rYpCyELa9nfGw1HxXmfj8hMtndf077Bat
 7AxNyUoLu8+C9vD2F0oqXGumYCkcXIoSyiDAPY2IuQENBE60O2sBCADlXsFRIss3rM3IW9dK
 8084c3kktyOyA0JO4cQtXglGVvmALIaqxLlQ8qabibmRgdozjh5YsYFIQwBasmD+0rZVEi7W
 OMc1pO/dbwAzlhzfmbAvkvzctB4CS2MP6RLkGR9MquiLAAWdfOiRoKeNkgSup8VlSPrvlXwF
 qsolEbH14LJGtJBF3uRUrhieyV+dQ5wE/UJCmuN/m1KWlZmcUeDbTefNM/NaWxSdycu27QyL
 PBMIS9bDHPoPAaPjRKoMr80aYbHLZxiXPXlP3wyfirWiN5jqL2mjcCqGqzAC2IPuWftD4oHr
 P+3w6cBi1noh1ps76iD37IUsU8tZgTX5sE8RABEBAAGJAR8EGAECAAkFAk60O2sCGwwACgkQ
 OCdr0NW4Dvq5ywf/ZEVxP1LOUnkab+B8ZDQs6L66bBMMuWaoUKp9ngdpSqKfSy6YnbmshKaE
 SkNBNlpVpdOweSBPnLx4ss2sksLwDxrQTxW71Zui67mUbdurhlkbsG1pM4c1sAcdqa7xG6nB
 +fkpwgn9bcvv3qQGuKDwit6fdIVnPRJckM1T8w8d0yG+0uNSzOhwKI6h8E0Za2ESLmTyfkr1
 FtSVF86xVAGMI8jMiccCzKfOlkP89ND84r5EDzeATa3Imv7xKCgcIlSuMQKk45506NFPQQlP
 nCTgp61XOM4EWjembxD6lWBXHltcm3K1dXvf3JbAxG7v2BSd0hRhnXfQdZoAzRJwYIHh2Q==
Message-ID: <6f727fe0-e9ac-2322-b9e1-532b25643d60@redhat.com>
Date:   Mon, 3 Jun 2019 16:11:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5190f63e-ce2a-f023-685c-f2d6f49fb211@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 03 Jun 2019 20:11:32 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/3/19 3:30 PM, Nathan Cutler wrote:
>> All runs were approved.
>> See only ceph-deploy that sees not bad, Sage.
>>
>> Also note that 3 commits were merged on top (related to upgrade/mimic-p2p fixes)
>>
>> I did not rerun all suites on the latest SHA1, so if this is a problem
>> pls speak up.
>>
>> Otherwise, Sage, Abhishek, Nathan, David ready for publishing.
> 
> The commits added all touch stuff under qa/ so I see no reason to re-run
> any suites.
> 
> Nathan
> 

I just noticed the job building Ceph was stuck waiting for a Xenial
arm64 builder all day.  The labels on the arm64 builders weren't set
correctly.

I've fixed that and arm64 debs are building now.  I'll get the release
cut before tomorrow but it'll be late.

JFYI.
