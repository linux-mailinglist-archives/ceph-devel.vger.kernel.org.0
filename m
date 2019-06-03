Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034973391A
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 21:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfFCTaW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 15:30:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:55702 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbfFCTaV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 15:30:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C13ECAF94;
        Mon,  3 Jun 2019 19:30:19 +0000 (UTC)
Subject: Re: 13.2.6 QE Mimic validation status
To:     Yuri Weinstein <yweinste@redhat.com>,
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
        Neha Ojha <nojha@redhat.com>,
        David Galloway <dgallowa@redhat.com>
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
 <CAC-Np1wR4ik58P=UPLuuBxhqbG_REx1UFp4mDPNdBiNQFW9W_g@mail.gmail.com>
 <CAMMFjmGro96-bhMOe2KGYjZLAu-6RrNKAvOom+wP3ovg_+ss7Q@mail.gmail.com>
 <fc64e04b-bae8-8e3c-a561-ab3d0d1489a3@redhat.com>
 <CAMMFjmFOGru6K3O00D9a+==VwZV4qBZKHHyjHsdCRm+CDi9jQg@mail.gmail.com>
From:   Nathan Cutler <ncutler@suse.cz>
Message-ID: <5190f63e-ce2a-f023-685c-f2d6f49fb211@suse.cz>
Date:   Mon, 3 Jun 2019 21:30:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAMMFjmFOGru6K3O00D9a+==VwZV4qBZKHHyjHsdCRm+CDi9jQg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------7D85369C90AA489B9F870412"
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------7D85369C90AA489B9F870412
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> All runs were approved.
> See only ceph-deploy that sees not bad, Sage.
>=20
> Also note that 3 commits were merged on top (related to upgrade/mimic-p=
2p fixes)
>=20
> I did not rerun all suites on the latest SHA1, so if this is a problem
> pls speak up.
>=20
> Otherwise, Sage, Abhishek, Nathan, David ready for publishing.

The commits added all touch stuff under qa/ so I see no reason to re-run
any suites.

Nathan

--------------7D85369C90AA489B9F870412
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

mQENBFyfl7kBCAChNAGzHfBLJieqmOGB1DLcYLLNrimTUF8HciWAPh+VSAJrUsls
bIs2RMkLdZCYXGTJhyovf3z0Wmu6WYiQlzHOxRj5EMoJCDKyA5546V9SeBzdo8AW
m4TPZj3Mw1ZNARBz2s5s80p86lfxm/XJZK/j54QVa4X/U89e+SrUlN+fUJ5PapGO
CCnnASG0NPegRTNLI258eKIPkQTE3iQYr47kHNCDGQ6yfjdKGob0+3EC2mDU9yTq
Vo67lkGAQaO9Vc3VjxcjEAZPFj/repdtNrDSsqD3tJ5wsLP0hO9YnBkxCHmqFNaj
zlGmCWbfUu5DDYs2VjobpFfvXvWLh2hsaHyPABEBAAG0H05hdGhhbiBDdXRsZXIg
PG5jdXRsZXJAc3VzZS5jej6JAVQEEwEIAD4WIQSZfz20SY3DgWchUUn2wrzlmzlN
HwUCXJ+XugIbAwUJAeEzgAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRD2wrzl
mzlNH3utCACR0Mxrb8BfQhiIKVSPBpf96+2qb5UcfBzQ7tQPpqwOvcPmTABmseLs
O/N9pxZOOS17wv/YT0Xwei8iH6vl4KeScsWk/Ri48N7EF/kI+X65XZNgjfWUSb+9
u7ep+tRlsoqhYTR+MSEVoOq8THrHYsVUF0KnrWjzwLNK4sh3L8t2UIiQ5fKj3km7
5BgU/bwEZPr7zEO85jyXXTv/6YGM5IsdcoFVLXF4y+iaqvib6BNThAGpG2/Gi3Gh
Deuw/MExhpmyOODRjKBvgVxin3da0dGmh7U+mMmrHui/prOunDObroncTiBTt6yF
ozgy6fL0ycPDY4CKePEFNvgxnaW2L/X2uQENBFyfl7oBCADCi+75MgoAXGCOJt17
FW+HQn4z88W8oWQRGun2kDFGk9vDZjoHFlTIswtelQBPvgVi3T4xqPocJxRzc6ny
hFhu51mHy7U7rhTClrUGGB28qujXudonQzygZfTOXWiNFgBn2bcTkDm8PVWvZQuV
8Fw6HdICJ5c4n/J5kgvet3Z1LQRb6IGjMEzNXf/5d6CKSLvMNepGKLDt3H8rSN67
eUfVLdTwG0wmLdxlJ+VQY+bCi27jy+4SrkKm1113AAznWBLcJJ1BKYFBKzlil9cg
2o6hJx41zrihtCpRn1S4d4Sp5SyApVpKt0J7tDyrlRcHwVQwq4GoRLewVndvDXsU
oZrpABEBAAGJATwEGAEIACYWIQSZfz20SY3DgWchUUn2wrzlmzlNHwUCXJ+XugIb
DAUJAeEzgAAKCRD2wrzlmzlNH4VaB/9qUXfkNOVOENq0hkeP9ECTSqJkPvodr1za
LOMCK8MONG7pTWu/c0JQv0pK322eHH9gi6Z5AoORvHOy9bKBWoTEZNpCBH/xNShg
o6q4OJBI6QXUY/LngJ0DSDUDIBGFGm9snMmC/QlwNn/OO7HULlAOBc2Sq5myZ+x5
0E866Wun9qBWC2OIdeWjd9OcPc9w6RIzyqJMhzjvIsYl4MsqguxTjXW0Xg0SYha8
eSrfb8mux+/hsLc3QCBALMVui/HTjGJwaMPWr5vnr6hRmnUBZZhHzEi+aHlYSMCg
buUz5+mY1EP4Ea9aG6AoU8eM7gjMSQmnaqHVesRd/X9wgw8GOMKf
=3D1sep
-----END PGP PUBLIC KEY BLOCK-----

--------------7D85369C90AA489B9F870412--
