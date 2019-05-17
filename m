Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472E7219F6
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2019 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfEQOrD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 May 2019 10:47:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:60352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728879AbfEQOrD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 May 2019 10:47:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 40D34AE51;
        Fri, 17 May 2019 14:47:02 +0000 (UTC)
To:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
From:   Nathan Cutler <ncutler@suse.cz>
Subject: Problem with nautilus-batch-1 label
Cc:     Yuri Weinstein <yweinste@redhat.com>,
        Abhishek Lekshmanan <abhishek@suse.com>
Message-ID: <fa7fd301-5135-91ae-8551-1c113a8587d5@suse.cz>
Date:   Fri, 17 May 2019 16:47:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------29DFB6DFA22CE56F364FFAF7"
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------29DFB6DFA22CE56F364FFAF7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We now have several nautilus PRs in integration testing even though they
did *not* pass make check.

This label should only be applied by members of the backporting team,
since it's the backporting team's responsibility to check that PRs have
been properly tested.

So, I'd like to take this opportunity to inform everyone what the
"nautilus-batch-1" label means. It means "I, the member of the
backporting team who is adding this label, do hereby certify that I have
personally checked that the PR has passed all the required Jenkins tests
("make check" in particular) and it looks good to go into integration
testing."

If you would like to add this label to PRs, please consult with me or
Abhishek before starting to use it.

Thanks,
Nathan

--------------29DFB6DFA22CE56F364FFAF7
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

--------------29DFB6DFA22CE56F364FFAF7--
